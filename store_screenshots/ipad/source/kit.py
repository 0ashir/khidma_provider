"""Shared building blocks for the Khidma Provider Play Store screenshots.
Everything inside .screen is in Flutter logical px for a 412x892dp phone
(DeviceType.largePhone: rw/rh/rs/rf x1). Colours are the light theme from
lib/utils/colors.dart; radii from UiUtils.borderRadiusOf*."""
import base64, os

HERE = os.path.dirname(os.path.abspath(__file__))

# Platform metrics in logical px: status bar height (sb) and bottom inset (gb).
# Android: 28 / 18 (gesture nav). iPhone: 54 / 34 (Dynamic Island, home indicator).
P = {"ios": False, "sb": 28, "gb": 18}


def set_platform(ios):
    P.update(ios=ios, sb=54 if ios else 28, gb=34 if ios else 18)

ACC = "#5465FF"                      # lightAccentColor
BG = "#F5F6F7"                       # lightPrimaryColor (scaffold)
CARD = "#FFFFFF"                     # lightSecondaryColor
TXT = "#00162E"                      # lightSubHeadingColor1 (blackColor)
GREY = "rgba(0,22,46,.5)"            # lightGreyColor = blackColor @ 0.5
HAIR = "rgba(0,22,46,.12)"           # lightGreyColor borders at width 0.2/0.5
ACC10 = "rgba(84,101,255,.1)"
ACC12 = "rgba(84,101,255,.12)"
ACC20 = "rgba(84,101,255,.2)"
GREEN = "#4CAF50"; RED = "#F44336"   # Colors.green / Colors.red
STAR = "#F4BE18"
STATUS = {                           # UiUtils.getStatusColor
    "awaiting": TXT, "pending": "#FF9900", "confirmed": "#009EA8", "approved": "#009EA8",
    "on_the_way": "#F44336", "started": ACC, "rescheduled": "#FF9900", "settled": "#FF9900",
    "cancelled": "#C60000", "rejected": "#C60000", "completed": "#1E9400",
}

MAT = {
    "add": "M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z",
    "delete_outline": "M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM8 9h8v10H8V9zm7.5-5l-1-1h-5l-1 1H5v2h14V4z",
    "more_vert": "M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z",
    "keyboard_arrow_up": "M7.41 15.41 12 10.83l4.59 4.58L18 14l-6-6-6 6z",
    "arrow_drop_down": "M7 10l5 5 5-5z",
    "arrow_forward_ios": "M6.23 20.23 8 22l10-10L8 2 6.23 3.77 14.46 12z",
    "call": "M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z",
    "help_outline": "M11 18h2v-2h-2v2zm1-16C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-14c-2.21 0-4 1.79-4 4h2c0-1.1.9-2 2-2s2 .9 2 2c0 2-3 1.75-3 5h2c0-2.25 3-2.5 3-5 0-2.21-1.79-4-4-4z",
    "format_list_bulleted": "M4 10.5c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm0-6c-.83 0-1.5.67-1.5 1.5S3.17 7.5 4 7.5 5.5 6.83 5.5 6 4.83 4.5 4 4.5zm0 12c-.83 0-1.5.68-1.5 1.5s.68 1.5 1.5 1.5 1.5-.68 1.5-1.5-.67-1.5-1.5-1.5zM7 19h14v-2H7v2zm0-6h14v-2H7v2zm0-8v2h14V5H7z",
}


def mat(name, size, color):
    return (f'<svg width="{size}" height="{size}" viewBox="0 0 24 24" style="flex:none;display:block">'
            f'<path d="{MAT[name]}" fill="{color}"/></svg>')


def svg_uri(name):
    data = open(os.path.join(HERE, "icons", name + ".svg"), "rb").read()
    return "data:image/svg+xml;base64," + base64.b64encode(data).decode()


def ic(name, size, color, extra="", h=None):
    """CustomSvgPicture(color:) == ColorFilter srcIn == alpha mask filled with colour."""
    u = svg_uri(name)
    return (f'<i class="ic" style="width:{size}px;height:{h or size}px;background:{color};'
            f'-webkit-mask-image:url({u});mask-image:url({u});{extra}"></i>')


def avatar(initials, size, bg="#E6E9FF", fg=ACC):
    return (f'<div style="width:{size}px;height:{size}px;border-radius:50%;background:{bg};flex:none;display:flex;'
            f'align-items:center;justify-content:center;color:{fg};font-weight:600;font-size:{size*0.38:.0f}px">{initials}</div>')


def status_bar(bg="transparent"):
    c = TXT
    if P["ios"]:
        return f"""<div class="statusbar ios" style="color:{c};background:{bg}">
  <span style="font-family:-apple-system,'SF Pro Text',Arial,sans-serif;font-size:17px;font-weight:600;width:54px;text-align:center">9:41</span><span class="grow"></span>
  <span class="row center" style="gap:7px">
    <svg width="18" height="12" viewBox="0 0 18 12"><rect x="0" y="8" width="3" height="4" rx="1" fill="{c}"/><rect x="5" y="5.5" width="3" height="6.5" rx="1" fill="{c}"/><rect x="10" y="3" width="3" height="9" rx="1" fill="{c}"/><rect x="15" y="0" width="3" height="12" rx="1" fill="{c}"/></svg>
    <svg width="17" height="12" viewBox="0 0 17 12"><path d="M8.5 2.3c2.4 0 4.6.9 6.2 2.5l1.2-1.2A10.4 10.4 0 0 0 8.5.6 10.4 10.4 0 0 0 1.1 3.6l1.2 1.2A8.7 8.7 0 0 1 8.5 2.3zm0 3.4c1.5 0 2.8.6 3.8 1.5l1.2-1.2A7 7 0 0 0 8.5 4a7 7 0 0 0-5 2l1.2 1.2c1-.9 2.3-1.5 3.8-1.5zm0 3.4c.6 0 1.1.2 1.5.6L8.5 11.2 7 9.7c.4-.4.9-.6 1.5-.6z" fill="{c}"/></svg>
    <svg width="27" height="13" viewBox="0 0 27 13"><rect x=".5" y=".5" width="23" height="12" rx="3.8" fill="none" stroke="{c}" opacity=".35"/><rect x="2" y="2" width="20" height="9" rx="2.5" fill="{c}"/><path d="M25 4.5v4c.8-.3 1.3-1.1 1.3-2s-.5-1.7-1.3-2z" fill="{c}" opacity=".4"/></svg>
  </span></div>"""
    return f"""<div class="statusbar" style="color:{c};background:{bg}">
  <span class="t14 w500" style="letter-spacing:.2px">9:41</span><span class="grow"></span>
  <span class="row center" style="gap:6px">
    <svg width="17" height="12" viewBox="0 0 17 12"><path d="M1 11h2V8H1zm4 0h2V6H5zm4 0h2V3.5H9zm4 0h2V1h-2z" fill="{c}"/></svg>
    <svg width="16" height="12" viewBox="0 0 16 12"><path d="M8 11.5 15.6 3.6A11 11 0 0 0 .4 3.6z" fill="{c}"/></svg>
    <svg width="24" height="12" viewBox="0 0 24 12"><rect x=".5" y=".5" width="20" height="11" rx="3" fill="none" stroke="{c}" opacity=".5"/><rect x="2" y="2" width="17" height="8" rx="1.6" fill="{c}"/><rect x="21.5" y="4" width="1.6" height="4" rx=".8" fill="{c}" opacity=".5"/></svg>
  </span></div>"""


def back_arrow():
    """UiUtils.getBackArrow: padding 15, back_arrow_light 20 tall, accent."""
    return f'<div style="width:56px;height:56px;display:flex;align-items:center;justify-content:center;flex:none">{ic("back_arrow_light", 11, ACC, h=20)}</div>'


def simple_app_bar(title, actions="", shadow=False, bottom=""):
    """UiUtils.getSimpleAppBar: white, title 16 w500, toolbar 56."""
    sh = "box-shadow:0 2px 6px rgba(0,0,0,.10);" if shadow else ""
    return f"""<div class="appbar" style="{sh}">
  {status_bar(CARD)}
  <div class="row center" style="height:56px">{back_arrow()}
    <span class="t16 w500 grow">{title}</span>{actions}</div>{bottom}</div>"""


def shadow_line():
    """CustomShadowLineForDevider(centerToSides)."""
    return '<div style="height:1px;width:100%;background:linear-gradient(90deg,transparent,rgba(0,0,0,.26),transparent)"></div>'


def gesture(bg="transparent"):
    if P["ios"]:
        return f'<div class="gesture ios" style="background:{bg}"><span></span></div>'
    return f'<div class="gesture" style="background:{bg}"><span></span></div>'


def safe_inset():
    """Tab screens sit in SafeArea: on iPhone nothing scrolls into the home-indicator inset."""
    if not P["ios"]:
        return ""
    return f'<div style="position:absolute;left:0;right:0;bottom:0;height:{P["gb"]}px;background:{BG};z-index:24"></div>'


def nav_bar(active):
    """MainActivity.bottomBar: floating 56px card, radius 10, 15px side / 10px bottom inset."""
    def item(icon, i):
        col = ACC if i == active else GREY
        return f'<div style="display:flex;padding-bottom:{2 if i == active else 0}px">{ic(icon, 25, col, h=24)}</div>'
    fab = (f'<div style="width:40px;height:40px;border-radius:50%;background:{ACC};display:flex;align-items:center;justify-content:center">'
           f'{mat("keyboard_arrow_up", 30, "#fff")}</div>')
    return f"""<div class="navbar" style="bottom:{P['gb'] + 10}px"><div class="row center" style="height:56px;justify-content:space-evenly">
  {item('home', 0)}{item('booking', 1)}{fab}{item('services', 2)}{item('chat', 3)}</div></div>{safe_inset()}{gesture()}"""


def big_header(title, sub, extra="", height=150):
    """LongAppBarPersistentHeaderDelegate (130-150) used by Bookings / Services tabs."""
    return f"""<div style="position:absolute;left:0;right:0;top:{P['sb']}px;height:{height}px;background:{BG};z-index:6;
  display:flex;flex-direction:column;justify-content:space-around">
  <div class="col center"><span class="w700" style="font-size:22px;line-height:1.25">{title}</span>
    <span style="font-size:16px;line-height:1.3;color:{GREY}">{sub}</span><div style="height:10px"></div>{shadow_line()}</div>
  {extra}</div>"""


def btn(label, h=48, extra=""):
    return f'<div class="btn" style="height:{h}px;{extra}">{label}</div>'


CSS = """
@font-face{font-family:'Outfit';src:url('fonts/Outfit-Variable.ttf') format('truetype');font-weight:100 900;font-display:block}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1080px;height:1920px;overflow:hidden;background:#3D4BE0}
body{font-family:'Outfit',sans-serif;-webkit-font-smoothing:antialiased}
.row{display:flex;flex-direction:row} .col{display:flex;flex-direction:column}
.center{align-items:center} .top{align-items:flex-start} .grow{flex:1 1 auto;min-width:0}
.ell{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.t10{font-size:10px;line-height:1.2} .t11{font-size:11px;line-height:1.2} .t12{font-size:12px;line-height:1.3}
.t13{font-size:13px;line-height:1.3} .t14{font-size:14px;line-height:1.3} .t16{font-size:16px;line-height:1.3}
.t18{font-size:18px;line-height:1.3} .t20{font-size:20px;line-height:1.25}
.w400{font-weight:400} .w500{font-weight:500} .w600{font-weight:600} .w700{font-weight:700}
.ic{display:inline-block;flex:none;-webkit-mask-size:contain;mask-size:contain;-webkit-mask-repeat:no-repeat;mask-repeat:no-repeat;
  -webkit-mask-position:center;mask-position:center}
.hr{height:1px;width:100%;background:rgba(0,22,46,.1);flex:none}

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
.screen{position:relative;width:412px;height:892px;border-radius:40px;overflow:hidden;background:#F5F6F7;color:#00162E}
.punch{position:absolute;top:9px;left:50%;width:12px;height:12px;margin-left:-6px;border-radius:50%;background:#0B0B0F;box-shadow:0 0 0 1.5px #1c1d24;z-index:50}

.statusbar{height:28px;display:flex;align-items:center;padding:0 22px 0 24px}
.appbar{position:absolute;left:0;top:0;right:0;background:#fff;z-index:10}
.gesture{position:absolute;left:0;right:0;bottom:0;height:18px;display:flex;justify-content:center;align-items:flex-start;z-index:30}
.statusbar.ios{height:54px;padding:6px 26px 0 24px}
.gesture.ios{height:34px;align-items:flex-end;padding-bottom:8px}
.gesture.ios span{width:134px;height:5px;border-radius:3px;background:#000;opacity:1;margin:0}
.gesture span{width:108px;height:4px;border-radius:2px;background:#00162E;opacity:.85;margin-top:7px}
.navbar{position:absolute;left:15px;right:15px;height:56px;border-radius:10px;background:#fff;z-index:25;
  box-shadow:0 6px 24px rgba(0,22,46,.10)}
.btn{border-radius:10px;background:#5465FF;color:#fff;font-size:14px;display:flex;align-items:center;justify-content:center;flex:1}
.card{background:#fff;border-radius:10px}
.sq{display:flex;align-items:center;justify-content:center;flex:none;border-radius:5px}
.float{position:absolute;transform-origin:top left;border-radius:10px;
  box-shadow:0 30px 60px rgba(14,20,90,.35),0 8px 18px rgba(14,20,90,.18)}
"""


IOS_CSS = """
html,body,.canvas{height:100vh}
.phone-wrap{top:610px;transform:translateX(-50%) scale(1.8)}
.phone{border-radius:62px;padding:12px;background:#0B0C10;
  box-shadow:0 0 0 2px #3B3D47 inset,0 0 0 1.5px #5A5C66,0 70px 140px rgba(10,14,60,.55),0 24px 48px rgba(10,14,60,.35)}
.screen{border-radius:50px}
.phone:before{right:-3px;top:185px;height:77px;background:#454650}
.phone:after{content:"";position:absolute;left:-3px;top:150px;width:3px;height:105px;border-radius:2px;
  background:linear-gradient(#454650 0 39%,transparent 39% 52%,#454650 52% 100%)}
.island{position:absolute;top:11px;left:50%;width:124px;height:35px;margin-left:-62px;border-radius:22px;background:#000;z-index:100}
.island:after{content:"";position:absolute;right:12px;top:12px;width:10px;height:10px;border-radius:50%;
  background:radial-gradient(circle at 38% 38%,#15253b,#070b12 65%);border:1px solid #11151d}
"""


def page(headline, sub, screen_inner, screen_bg=BG, extra_html="", deco=0):
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
<style>{CSS}{IOS_CSS if P["ios"] else ""}</style></head><body>
<div class="canvas">
  {blobs}
  <div class="copy">
    <div class="chip"><img src="img/brand.png">Khidma Provider</div>
    <div class="h1">{headline}</div>
    <div class="sub">{sub}</div>
  </div>
  <div class="phone-wrap"><div class="phone"><div class="screen" style="background:{screen_bg}">
    {screen_inner}
    {'<div class="island"></div>' if P["ios"] else '<div class="punch"></div>'}
  </div></div></div>
  {extra_html}
</div></body></html>"""
