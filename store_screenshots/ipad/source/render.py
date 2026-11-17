"""Regenerates the HTML and renders the store PNGs.
  python render.py [name ...]         Android: 1080x1920 into store_screenshots/
  python render.py --ios [name ...]   iPhone: 1206x2622 and 1320x2868 into store_screenshots/ios/
No names = all eight."""
import json, math, subprocess, sys
from pathlib import Path
from playwright.sync_api import sync_playwright
from PIL import Image, ImageDraw, ImageOps

HERE = Path(__file__).resolve().parent
OUT = HERE.parent
NAMES = ["01_home", "02_bookings", "03_booking", "04_services", "05_jobs", "06_chat", "07_hours", "08_withdraw"]
IOS_SIZES = [(1206, 2622), (1320, 2868)]   # App Store: 6.3" and 6.9" iPhone displays

args = sys.argv[1:]
ios = "--ios" in args
names = [a for a in args if not a.startswith("--")] or NAMES
subprocess.run([sys.executable, str(HERE / "screens.py")] + (["ios"] if ios else []), check=True, cwd=HERE)


def shoot(page, html, dest, width, height):
    page.goto(html.as_uri(), wait_until="networkidle")
    page.evaluate("document.fonts.ready")
    if not page.evaluate("document.fonts.check('600 16px Outfit')"):
        raise SystemExit(f"{html.name}: Outfit font did not load")
    missing = page.evaluate("Array.from(document.images).filter(i=>!i.complete||!i.naturalWidth).map(i=>i.src)")
    if missing:
        raise SystemExit(f"{html.name}: missing images {missing}")
    page.screenshot(path=str(dest))
    with Image.open(dest) as im:
        rgb = im.convert("RGB")                 # opaque, no alpha
    if rgb.size != (width, height):             # rounding of the CSS viewport: trim to exact pixels
        if rgb.width != width or rgb.height < height:
            raise SystemExit(f"{dest}: unexpected size {rgb.size}")
        rgb = rgb.crop((0, 0, width, height))
    rgb.save(dest)
    with Image.open(dest) as v:
        assert v.size == (width, height) and v.mode == "RGB", (dest, v.size, v.mode)
    print("rendered", dest.relative_to(OUT), f"{width}x{height}")


with sync_playwright() as p:
    try:
        browser = p.chromium.launch(channel="chrome")
    except Exception:
        browser = p.chromium.launch()
    if not ios:
        page = browser.new_page(viewport={"width": 1080, "height": 1920}, device_scale_factor=1)
        for name in names:
            shoot(page, HERE / f"{name}.html", OUT / f"{name}_en.png", 1080, 1920)
    else:
        report = []
        for w, h in IOS_SIZES:
            dsf = w / 1080
            folder = OUT / "ios" / f"iphone_{w}x{h}"
            folder.mkdir(parents=True, exist_ok=True)
            page = browser.new_page(viewport={"width": 1080, "height": math.ceil(h / dsf)}, device_scale_factor=dsf)
            for name in names:
                dest = folder / f"{name}_en.png"
                shoot(page, HERE / f"ios_{name}.html", dest, w, h)
                report.append({"file": str(dest.relative_to(OUT / "ios")), "width": w, "height": h, "mode": "RGB"})
            page.close()
        if names == NAMES:
            (OUT / "ios" / "validation.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
            sheet = Image.new("RGB", (1200, 1350), "#e8e9ef")
            d = ImageDraw.Draw(sheet)
            for i, name in enumerate(NAMES):
                with Image.open(OUT / "ios" / "iphone_1206x2622" / f"{name}_en.png") as im:
                    x, y = (i % 4) * 300 + 10, (i // 4) * 675 + 30
                    sheet.paste(ImageOps.contain(im, (280, 610)), (x, y))
                    d.text((x, y - 18), name, fill="#222")
            sheet.save(OUT / "ios" / "preview.jpg", quality=92)
    browser.close()
