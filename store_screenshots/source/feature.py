"""Google Play feature graphic (1024x500, 24-bit PNG, no alpha) for Khidma Provider.
Same canvas and type as the phone screenshots; the cards are the real dashboard
components (Earning Report table, BookingCardContainer awaiting state) from screens.py.
Run: python feature.py   -> ../feature_graphic_1024x500.png"""
from pathlib import Path
from playwright.sync_api import sync_playwright
from PIL import Image
from screens import *

FEATURE_CSS = """
html,body{width:1024px;height:500px}
.fcanvas{position:relative;width:1024px;height:500px;overflow:hidden;color:#fff;
  background:radial-gradient(90% 120% at 88% 0%,#7B88FF 0%,rgba(123,136,255,0) 60%),
             linear-gradient(160deg,#5F6FFF 0%,#5465FF 40%,#3F4CE6 75%,#2E39C2 100%)}
.fcopy{position:absolute;left:84px;top:0;bottom:0;width:500px;display:flex;flex-direction:column;justify-content:center}
.mark{display:inline-flex;align-self:flex-start;padding:7px 18px;border-radius:999px;background:rgba(255,255,255,.14);
  border:1.5px solid rgba(255,255,255,.22);font-size:20px;font-weight:600;letter-spacing:.3px}
.fh1{margin-top:20px;font-size:52px;line-height:1.02;font-weight:700;letter-spacing:-1.1px}
.fh1 em{font-style:normal;color:#D9DDFF}
.fsub{margin-top:16px;font-size:21px;line-height:1.35;color:rgba(255,255,255,.86)}
.fcard{position:absolute;color:#00162E;border-radius:10px;
  box-shadow:0 26px 50px rgba(14,20,90,.38),0 8px 18px rgba(14,20,90,.20)}
"""


def earnings():
    def item(t, v):
        return f'<div class="col"><span class="t14 ell" style="color:{ACC}">{t}</span><div style="height:4px"></div><span class="t18 w600">{v}</span></div>'
    return f"""<div class="card" style="padding:15px">
  <div class="t16 w600">Earning Report</div><div style="height:10px"></div>
  <div style="display:grid;grid-template-columns:1fr 1fr;row-gap:10px;column-gap:12px">
    {item('My Income', 'AED18,640')}{item('Remaining Income', 'AED4,860')}{item('Admin Commission', 'AED2,796')}{item('Future Earning', 'AED1,369')}
  </div></div>"""


html = f"""<!doctype html><html><head><meta charset="utf-8"><style>{CSS}{FEATURE_CSS}</style></head><body>
<div class="fcanvas">
  <span class="blob" style="width:420px;height:420px;right:-120px;top:-210px"></span>
  <span class="blob" style="width:300px;height:300px;left:-150px;bottom:-170px"></span>
  <span class="ring" style="width:560px;height:560px;left:380px;top:180px"></span>
  <div class="fcopy">
    <div class="mark">Khidma Provider</div>
    <div class="fh1">Grow your business,<br><em>all in one app</em></div>
    <div class="fsub">Accept bookings, manage jobs<br>&amp; track your earnings</div>
  </div>
  <div class="fcard" style="left:620px;top:40px;width:300px;transform:rotate(2deg)">{earnings()}</div>
  <div class="fcard" style="left:652px;top:196px;width:300px;transform:rotate(-2.5deg)">{booking_card(B_NEW)}</div>
</div></body></html>"""

if __name__ == "__main__":
    src = Path(HERE) / "feature.html"
    dest = Path(HERE).parent / "feature_graphic_1024x500.png"
    src.write_text(html, encoding="utf-8")
    with sync_playwright() as p:
        try:
            browser = p.chromium.launch(channel="chrome")
        except Exception:
            browser = p.chromium.launch()
        page = browser.new_page(viewport={"width": 1024, "height": 500}, device_scale_factor=1)
        page.goto(src.as_uri(), wait_until="networkidle")
        page.evaluate("document.fonts.ready")
        if not page.evaluate("document.fonts.check('600 16px Outfit')"):
            raise SystemExit("Outfit font did not load")
        page.screenshot(path=str(dest))
        browser.close()
    Image.open(dest).convert("RGB").save(dest)     # 24-bit, no alpha
    with Image.open(dest) as v:
        assert v.size == (1024, 500) and v.mode == "RGB", (v.size, v.mode)
    print("rendered", dest, "1024x500 RGB")
