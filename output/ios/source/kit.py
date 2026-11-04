"""Shared building blocks for the Khidma Plus Play Store screenshots.
Everything inside .screen is in Flutter logical px for a 412x892dp phone
(DeviceType.largePhone: rw/rh x1, rs x0.9, rf x1). Colours are the Kigen
light tokens from lib/theme/kigen."""
import base64, os

HERE = os.path.dirname(os.path.abspath(__file__))

BRAND = "#5465FF"; BRAND_SUBTLE = "#EEEFFF"
BG1 = "#FFFFFF"; BG2 = "#F7F7F7"; BG3 = "#EDEDED"
TXT1 = "#1A1A1A"; TXT2 = "#7A7A7A"; TXT3 = "#BFBFBF"
ICON1 = "#1A1A1A"; ICON2 = "#7A7A7A"
SUCCESS = "#20B364"; SUCCESS_SUBTLE = "#E5FAEF"
BORDER = "#EDEDED"; BORDER_MUTED = "#F7F7F7"; BORDER_STRONG = "#BFBFBF"
RS = 0.9

# Material icons used by the app (Icons.add / remove / delete_outline / more_vert)
MAT = {
    "chevron_right": "M10 6 8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z",
    "keyboard_arrow_up": "M7.41 15.41 12 10.83l4.59 4.58L18 14l-6-6-6 6z",
    "add": "M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z",
    "delete_outline": "M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM8 9h8v10H8V9zm7.5-5l-1-1h-5l-1 1H5v2h14V4z",
    "more_vert": "M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z",
}


def mat(name, size, color):
    return (f'<svg width="{size}" height="{size}" viewBox="0 0 24 24" style="flex:none;display:block">'
            f'<path d="{MAT[name]}" fill="{color}"/></svg>')


def svg_uri(name):
    data = open(os.path.join(HERE, "icons", name + ".svg"), "rb").read()
    return "data:image/svg+xml;base64," + base64.b64encode(data).decode()


def ic(name, size, color, extra=""):
    """CustomSvgPicture(color:) == ColorFilter srcIn == alpha mask filled with colour."""
    u = svg_uri(name)
    return (f'<i class="ic" style="width:{size}px;height:{size}px;background:{color};'
            f'-webkit-mask-image:url({u});mask-image:url({u});{extra}"></i>')


def raw_svg(name, size):
    return f'<img src="{svg_uri(name)}" style="width:{size}px;height:{size}px;display:block">'


def status_bar(dark=True):
    c = TXT1 if dark else "#fff"
    return f"""<div class="statusbar" style="color:{c}">
  <span class="t14 w500" style="letter-spacing:.2px">9:41</span><span class="grow"></span>
  <span class="row center" style="gap:6px">
    <svg width="17" height="12" viewBox="0 0 17 12"><path d="M1 11h2V8H1zm4 0h2V6H5zm4 0h2V3.5H9zm4 0h2V1h-2z" fill="{c}"/></svg>
    <svg width="16" height="12" viewBox="0 0 16 12"><path d="M8 11.5 15.6 3.6A11 11 0 0 0 .4 3.6z" fill="{c}"/></svg>
    <svg width="24" height="12" viewBox="0 0 24 12"><rect x=".5" y=".5" width="20" height="11" rx="3" fill="none" stroke="{c}" opacity=".5"/><rect x="2" y="2" width="17" height="8" rx="1.6" fill="{c}"/><rect x="21.5" y="4" width="1.6" height="4" rx=".8" fill="{c}" opacity=".5"/></svg>
  </span></div>"""


def back_arrow():
    """UiUtils.getBackArrow: margin 8, padding 8, white circle, left_arrow 24.rs."""
    return f'<div class="backbtn">{ic("left_arrow", 24*RS, ICON1)}</div>'


def simple_app_bar(title_html, actions="", shadow=True, height=56):
    sh = "box-shadow:0 8px 16px rgba(0,0,0,.04);" if shadow else ""
    return f"""<div class="appbar" style="{sh}">
  {status_bar(True)}
  <div class="row center" style="height:{height}px">
    {back_arrow()}
    <div class="grow" style="padding-left:0">{title_html}</div>
    {actions}
  </div></div>"""


def gesture(bg="#fff"):
    return f'<div class="gesture" style="background:{bg}"><span></span></div>'


def stepper(qty, height=32, pad=10, icon=16, count=14, width=None):
    """AddButton with alreadyAddedQuantity > 0 (spacing 12)."""
    first = "delete_outline" if qty == 1 else "remove"
    return f"""<div class="stepper" style="height:{height}px;padding:0 {pad}px">
  {mat(first, icon, BRAND)}<span class="w500" style="font-size:{count}px;color:{BRAND}">{qty}</span>{mat('add', icon, BRAND)}</div>"""


def add_btn(height=32, pad=10):
    return f'<div class="add-btn" style="height:{height}px;padding:0 {pad}px">ADD</div>'


def cart_bar(images, qty, total):
    av = "".join(
        f'<img src="img/{im}" style="position:absolute;left:{i*16}px;top:0;width:24px;height:24px;border-radius:50%;'
        f'border:1.5px solid #fff;object-fit:cover">' for i, im in enumerate(images))
    w = 24 + (len(images) - 1) * 16
    noun = "services" if qty > 1 else "service"
    return f"""<div class="cartbar-wrap"><div class="cartbar">
  <div style="position:relative;width:{w}px;height:24px;flex:none">{av}</div>
  <div class="row center grow"><span class="t16 w500" style="color:#fff">{qty} {noun}</span>
    <span style="width:4px"></span><span style="width:4px;height:4px;border-radius:50%;background:#fff"></span><span style="width:4px"></span>
    <span class="t16 w500" style="color:#fff">{total}</span></div>
  <div class="row center" style="gap:8px;padding:0 8px"><span class="t14" style="color:#fff">Continue</span>{ic('back_arrow_ltr', 18, '#fff')}</div>
</div></div>"""


CSS = """
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1080px;height:1920px;overflow:hidden;background:#3D4BE0}
body{font-family:'Outfit',sans-serif;-webkit-font-smoothing:antialiased}
.row{display:flex;flex-direction:row} .col{display:flex;flex-direction:column}
.center{align-items:center} .top{align-items:flex-start} .grow{flex:1 1 auto;min-width:0}
.ell{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.t11{font-size:11px;line-height:1.2} .t12{font-size:12px;line-height:1.25} .t14{font-size:14px;line-height:1.25}
.t16{font-size:16px;line-height:1.25} .t24{font-size:24px;line-height:1.25}
.w400{font-weight:400} .w500{font-weight:500} .w600{font-weight:600} .w700{font-weight:700}
.ic{display:inline-block;flex:none;-webkit-mask-size:100% 100%;mask-size:100% 100%;-webkit-mask-repeat:no-repeat}
.dot{width:4px;height:4px;border-radius:50%;background:#EDEDED;flex:none;display:inline-block}
.dash{height:1px;width:100%;flex:none;background:repeating-linear-gradient(90deg,#BFBFBF 0 4px,transparent 4px 8px)}
.divider{height:1px;width:100%;background:#EDEDED;flex:none}

.canvas{position:relative;width:1080px;height:1920px;overflow:hidden;
  background:radial-gradient(120% 70% at 85% 0%,#7B88FF 0%,rgba(123,136,255,0) 60%),
             linear-gradient(165deg,#5F6FFF 0%,#5465FF 38%,#3F4CE6 72%,#2E39C2 100%)}
.blob{position:absolute;border-radius:50%;background:rgba(255,255,255,.07)}
.ring{position:absolute;border-radius:50%;border:2px solid rgba(255,255,255,.10)}
.copy{position:absolute;left:60px;right:60px;top:118px;text-align:center;color:#fff}
.chip{display:inline-flex;align-items:center;gap:14px;padding:10px 26px 10px 10px;border-radius:999px;
  background:rgba(255,255,255,.14);border:1.5px solid rgba(255,255,255,.22);font-size:30px;font-weight:600;letter-spacing:.3px}
.chip img{width:50px;height:50px;border-radius:14px}
.h1{margin-top:34px;font-size:86px;line-height:1.02;font-weight:700;letter-spacing:-1.6px}
.h1 em{font-style:normal;color:#D9DDFF}
.sub{margin-top:22px;font-size:34px;line-height:1.3;font-weight:400;color:rgba(255,255,255,.86)}
.phone-wrap{position:absolute;left:50%;top:528px;transform-origin:top center;transform:translateX(-50%) scale(1.45)}
.phone{position:relative;width:436px;height:916px;border-radius:52px;padding:12px;background:#0E0F14;
  box-shadow:0 0 0 2px #2A2C36 inset,0 0 0 1.5px #3A3D4A,0 60px 120px rgba(10,14,60,.55),0 20px 40px rgba(10,14,60,.35)}
.phone:before{content:"";position:absolute;right:-3px;top:190px;width:3px;height:80px;border-radius:2px;background:#24262F}
.screen{position:relative;width:412px;height:892px;border-radius:40px;overflow:hidden;background:#F7F7F7;color:#1A1A1A}
.punch{position:absolute;top:9px;left:50%;width:12px;height:12px;margin-left:-6px;border-radius:50%;background:#0B0B0F;box-shadow:0 0 0 1.5px #1c1d24;z-index:50}

.statusbar{height:28px;display:flex;align-items:center;padding:0 22px 0 24px}
.appbar{position:absolute;left:0;top:0;right:0;background:#fff;z-index:10}
.backbtn{margin:8px;padding:8px;border-radius:50%;background:#fff;display:flex;flex:none}
.gesture{position:absolute;left:0;right:0;bottom:0;height:18px;display:flex;justify-content:center;align-items:flex-start;z-index:30}
.gesture span{width:108px;height:4px;border-radius:2px;background:#1A1A1A;opacity:.85;margin-top:7px}
.stepper{display:flex;align-items:center;gap:12px;border-radius:8px;background:#EEEFFF;border:1px solid #5465FF;flex:none}
.add-btn{display:flex;align-items:center;justify-content:center;border-radius:8px;background:#EEEFFF;border:1px solid #5465FF;color:#5465FF;font-size:14px;flex:none}
.cartbar-wrap{position:absolute;left:0;right:0;bottom:18px;background:#fff;padding:12px 16px;z-index:20}
.cartbar{height:48px;border-radius:16px;background:#5465FF;padding:12px;display:flex;align-items:center;gap:8px;box-shadow:0 -4px 24px rgba(0,0,0,.08)}
.circle-btn{padding:8px;border-radius:50%;background:#fff;display:flex;flex:none}
.btn{height:48px;border-radius:12px;background:#5465FF;color:#fff;font-size:16px;font-weight:500;display:flex;align-items:center;justify-content:center}
"""


def page(headline, sub, screen_inner, screen_bg=BG2, extra_html="", deco=0, head_extra=""):
    blobs = [
        '<span class="blob" style="width:520px;height:520px;right:-180px;top:-160px"></span>'
        '<span class="blob" style="width:380px;height:380px;left:-170px;top:820px"></span>'
        '<span class="ring" style="width:760px;height:760px;left:-300px;top:1240px"></span>'
        '<span class="ring" style="width:540px;height:540px;right:-260px;top:520px"></span>',
        '<span class="blob" style="width:520px;height:520px;left:-200px;top:-180px"></span>'
        '<span class="blob" style="width:420px;height:420px;right:-200px;top:900px"></span>'
        '<span class="ring" style="width:760px;height:760px;right:-320px;top:1180px"></span>'
        '<span class="ring" style="width:540px;height:540px;left:-280px;top:560px"></span>',
    ][deco % 2]
    return f"""<!doctype html><html><head><meta charset="utf-8">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=block" rel="stylesheet">
<style>{CSS}</style>{head_extra}</head><body>
<div class="canvas">
  {blobs}
  <div class="copy">
    <div class="chip"><img src="img/r_brand.png">Khidma Plus</div>
    <div class="h1">{headline}</div>
    <div class="sub">{sub}</div>
  </div>
  <div class="phone-wrap"><div class="phone"><div class="screen" style="background:{screen_bg}">
    {screen_inner}
    <div class="punch"></div>
  </div></div></div>
  {extra_html}
</div></body></html>"""
