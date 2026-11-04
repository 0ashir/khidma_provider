"""Builds home.html: a code-faithful replica of the Khidma Plus customer home
screen (lib/ui/screens/homeScreen/*) inside a 1080x1920 Play Store frame.
All sizes inside .screen are Flutter logical px for a 412dp-wide phone
(DeviceType.largePhone: rw/rh x1, rs x0.9, rf x1)."""
import base64, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ICONS = os.path.join(HERE, "icons")


def svg_uri(name):
    data = open(os.path.join(ICONS, name + ".svg"), "rb").read()
    return "data:image/svg+xml;base64," + base64.b64encode(data).decode()


def ic(name, size, color, extra=""):
    """CustomSvgPicture with colorFilter srcIn == alpha mask filled with color."""
    u = svg_uri(name)
    return (f'<i class="ic" style="width:{size}px;height:{size}px;background:{color};'
            f'-webkit-mask-image:url({u});mask-image:url({u});{extra}"></i>')


# ---- Kigen light tokens (lib/theme/kigen) ----
BRAND = "#5465FF"; BRAND_SUBTLE = "#EEEFFF"
BG1 = "#FFFFFF"; BG2 = "#F7F7F7"; BG3 = "#EDEDED"
TXT1 = "#1A1A1A"; TXT2 = "#7A7A7A"; TXT3 = "#BFBFBF"
ICON1 = "#1A1A1A"; ICON2 = "#7A7A7A"
WARN_SUBTLE = "#FEF5E6"; SUCCESS_SUBTLE = "#E5FAEF"
BORDER_STRONG = "#BFBFBF"

RS = 0.9            # num.rs() on a large phone
SIDE = 15 * RS      # HomeSections._sideInset.rs()


def service_card(img, title, price, minutes):
    return f"""
<div class="svc-card">
  <div class="row top" style="gap:8px">
    <img class="svc-img" src="img/{img}">
    <div class="col grow">
      <div class="row">
        <span class="t14 w500 ell grow" style="color:{TXT1}">{title}</span>
        {ic('dr_favorite', 24, ICON1)}
      </div>
      <div style="height:4px"></div>
      <div class="row center">
        {ic('users', 16, ICON2)}<span class="sp4"></span>
        <span class="t12" style="color:{TXT2}">1 Person</span><span class="sp4"></span>
        <span class="dot"></span><span class="sp4"></span>
        {ic('clock', 16, ICON2)}<span class="sp4"></span>
        <span class="t12" style="color:{TXT2}">{minutes} Minutes</span>
      </div>
      <div style="height:8px"></div>
      <div class="row center">
        <span class="t11" style="color:{TXT2}">By&nbsp;</span>
        <span class="t12" style="color:{TXT1};text-decoration:underline">bareeq plus</span>
      </div>
    </div>
  </div>
  <div class="dash"></div>
  <div class="row center">
    <div class="col grow" style="gap:4px">
      <span class="t14 w600" style="color:{TXT1}">{price}</span>
      <div style="height:16px"></div>
    </div>
    <div class="add-btn">ADD</div>
  </div>
</div>"""


def category_item(img, name, width=None):
    w = f"width:{width}px;" if width else ""
    return f"""
<div class="cat-item" style="{w}">
  <div class="cat-circle"><img src="img/{img}" style="width:{24*RS}px;height:{24*RS}px;object-fit:contain"></div>
  <div style="height:6px"></div>
  <span class="t12 ell" style="color:{TXT1};text-align:center;max-width:100%">{name}</span>
</div>"""


def section_title(title, view_all=True):
    va = f'<span class="t14" style="color:{BRAND}">View All</span>' if view_all else ""
    return f"""<div class="row center" style="padding:0 {SIDE}px;gap:16px">
  <span class="t16 w500 grow ell" style="color:{TXT1}">{title}</span>{va}</div>"""


def nav_item(icon, label, active=False):
    if active:
        icon_html = (f'<div style="padding:4px 8px;border-radius:16px;background:{BRAND_SUBTLE};display:flex">'
                     f'{ic(icon, 24, BRAND)}</div>')
        lab = f'<span class="t12 w600" style="color:{BRAND};line-height:18px">{label}</span>'
    else:
        icon_html = f'<div style="padding:4px;display:flex">{ic(icon, 24, ICON2)}</div>'
        lab = f'<span class="t12" style="color:{TXT2};line-height:18px">{label}</span>'
    return f'<div class="nav-item">{icon_html}{lab}</div>'


STATUS_ICONS = """
<svg width="17" height="12" viewBox="0 0 17 12"><path d="M1 11h2V8H1zm4 0h2V6H5zm4 0h2V3.5H9zm4 0h2V1h-2z" fill="#fff"/></svg>
<svg width="16" height="12" viewBox="0 0 16 12"><path d="M8 11.5 15.6 3.6A11 11 0 0 0 .4 3.6z" fill="#fff"/></svg>
<svg width="24" height="12" viewBox="0 0 24 12"><rect x=".5" y=".5" width="20" height="11" rx="3" fill="none" stroke="#fff" opacity=".55"/><rect x="2" y="2" width="17" height="8" rx="1.6" fill="#fff"/><rect x="21.5" y="4" width="1.6" height="4" rx=".8" fill="#fff" opacity=".55"/></svg>
"""

screen = f"""
<div class="screen">
  <div class="scroll">
    <div style="height:{28+12+40+16+48+16}px"></div>
    <div style="height:25px"></div>

    <!-- SliderImageWidget: height 200.rs, padding 15.rs, radius 10 -->
    <div class="slider" style="height:{200*RS}px;padding:0 {SIDE}px">
      <div class="slide"><img src="img/r_slider0.jpg"></div>
      <div class="indicator">
        <span class="ind on"></span><span class="ind"></span><span class="ind"></span><span class="ind"></span>
      </div>
    </div>
    <div style="height:24px"></div>

    <!-- all_categories -->
    {section_title('Service Category')}
    <div style="height:12px"></div>
    <div style="padding:0 {SIDE}px"><div class="cat-card">
      <div class="cat-grid">
        {category_item('r_cat3.png','Hourly Maids')}
        {category_item('r_cat6.png','Car wash')}
        {category_item('r_cat12.png','Car polishing')}
      </div>
    </div></div>

    <!-- custom_job_requests -->
    <div style="padding:24px {SIDE}px 0">
      <div class="req">
        <span class="circ" style="top:-48px;right:-64px;width:128px;height:128px"></span>
        <span class="circ" style="bottom:-48px;left:-48px;width:96px;height:96px"></span>
        <div class="col" style="align-items:center;gap:16px;padding:16px 8px;position:relative">
          <div class="col" style="align-items:center">
            <span class="t16 w700" style="color:{TXT1};text-align:center">Can't find your service? Request it</span>
            <span class="t12" style="color:{TXT1};text-align:center">Tell us what you need and send a custom service request.</span>
          </div>
          <div class="req-btn">Request Service</div>
        </div>
      </div>
    </div>

    <!-- categories (featured, <4 items -> horizontal row of 64px items) -->
    <div style="height:24px"></div>
    {section_title('Explore services', view_all=False)}
    <div style="height:12px"></div>
    <div style="padding:0 {SIDE}px"><div class="cat-card"><div class="row top" style="gap:12px">
      {category_item('r_cat3.png','Hourly Maids',64)}
      {category_item('r_cat6.png','Car wash',64)}
      {category_item('r_cat12.png','Car polishing',64)}
    </div></div></div>

    <!-- recommended_service -->
    <div style="height:24px"></div>
    {section_title('Services')}
    <div style="height:8px"></div>
    <div class="hscroll" style="padding:0 {SIDE}px">
      <div style="width:305px;margin-right:12px">{service_card('r_svc10.jpg','steam wash salon','AED400','120')}</div>
      <div style="width:305px;margin-right:12px">{service_card('r_svc11.jpg','steam wash 4x4','AED500','120')}</div>
    </div>
  </div>

  <!-- HomeHeader (drawn over the scroll, like the Column/Expanded layout) -->
  <div class="header">
    <div class="statusbar">
      <span class="t14 w500" style="color:#fff;letter-spacing:.2px">9:41</span>
      <span class="grow"></span>
      <span class="row center" style="gap:6px">{STATUS_ICONS}</span>
    </div>
    <div class="row center" style="padding-bottom:16px">
      <div class="row center grow" style="min-width:0">
        <div class="avatar">{ic('user', 24, ICON1)}</div>
        <div style="width:8px"></div>
        <div class="col grow" style="min-width:0">
          <div class="row center" style="min-width:0">
            <span class="t14 w700 ell" style="color:#fff">Al Markaziyah, Abu Dhabi, United Arab Emirates</span>
            <span style="width:4px;flex:none"></span>{ic('down_arrow', 20, '#fff', 'flex:none')}
          </div>
          <span class="t12 ell" style="color:#fff">Abu Dhabi</span>
        </div>
      </div>
      <div style="width:12px"></div>
      <div class="bell">{ic('notification', 24, ICON1)}</div>
    </div>
    <div class="search">
      {ic('search', 24, ICON1)}<span style="width:8px"></span>
      <span class="t14" style="color:{TXT1}">Search providers here</span>
    </div>
  </div>

  <!-- CustomNavigationBar -->
  <div class="navbar">
    <div class="row" style="justify-content:space-around;padding:8px 4px">
      {nav_item('active_explore','Explore',True)}
      {nav_item('inactive_booking','Bookings')}
      {nav_item('inactive_chat','Chat')}
      {nav_item('inactive_my_req','Requests')}
      {nav_item('inactive_profile','Profile')}
    </div>
    <div class="gesture"><span></span></div>
  </div>
  <div class="punch"></div>
</div>"""

# Provider card (near_by_provider, layout style_1, highlightStat distance) - floated outside the phone
provider_card = f"""
<div class="prov-card">
  <div style="position:relative">
    <img src="img/r_provbanner5.jpg" style="display:block;width:100%;height:162px;object-fit:cover;border-radius:12px 12px 0 0">
    <div style="position:absolute;top:8px;right:8px;padding:4px;border-radius:4px;background:rgba(0,0,0,.04);display:flex">{ic('dr_favorite', 24, '#fff')}</div>
    <div class="prov-float">
      <img src="img/r_prov5.jpg" style="width:48px;height:48px;border-radius:6px;object-fit:cover;flex:none">
      <div class="col grow" style="gap:4px;min-width:0">
        <span class="t14 w500 ell" style="color:{TXT1}">bareeq plus</span>
        <div class="row center" style="gap:4px">
          <div class="row center" style="gap:4px;padding:4px;border-radius:8px;background:{BRAND_SUBTLE}">
            {ic('map_pin_area', 16, BRAND)}<span class="t12" style="color:{BRAND}">25 km</span></div>
          <span class="dot"></span>{ic('service', 16, ICON2)}<span class="t12" style="color:{TXT2}">25 service</span>
        </div>
      </div>
    </div>
  </div>
  <div class="col" style="gap:12px;padding:42px 12px 12px">
    <div class="t12 ell" style="color:{TXT1};background:{SUCCESS_SUBTLE};border-radius:4px;padding:4px 8px">Next Available : Today, 11:00 PM To 12:00 AM</div>
    <div class="dash"></div>
    <div class="row center" style="gap:16px">
      <div class="col grow" style="gap:4px">
        <span class="t12" style="color:{TXT2}">Starting From</span>
        <span class="t14 w600" style="color:{TXT1}">AED75</span>
      </div>
      <div style="padding:8px;border-radius:50%;background:{BG2};display:flex">{ic('back_arrow_ltr', 20, ICON1)}</div>
    </div>
  </div>
</div>"""

floating_service = f'<div style="width:305px">{service_card("r_svc12.jpg","deep wash salon","AED249","90")}</div>'

html = f"""<!doctype html><html><head><meta charset="utf-8">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=block" rel="stylesheet">
<style>
*{{box-sizing:border-box;margin:0;padding:0}}
html,body{{width:1080px;height:1920px;overflow:hidden;background:#3D4BE0}}
body{{font-family:'Outfit',sans-serif;-webkit-font-smoothing:antialiased}}
.row{{display:flex;flex-direction:row}} .col{{display:flex;flex-direction:column}}
.center{{align-items:center}} .top{{align-items:flex-start}} .grow{{flex:1 1 auto;min-width:0}}
.ell{{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}}
.t11{{font-size:11px;line-height:1.2}} .t12{{font-size:12px;line-height:1.25}} .t14{{font-size:14px;line-height:1.25}} .t16{{font-size:16px;line-height:1.25}}
.w500{{font-weight:500}} .w600{{font-weight:600}} .w700{{font-weight:700}}
.ic{{display:inline-block;flex:none;-webkit-mask-size:100% 100%;mask-size:100% 100%;-webkit-mask-repeat:no-repeat}}
.sp4{{width:4px;flex:none}}
.dot{{width:4px;height:4px;border-radius:50%;background:{BG3};flex:none;display:inline-block}}
.dash{{height:1px;width:100%;background:repeating-linear-gradient(90deg,{BORDER_STRONG} 0 4px,transparent 4px 8px)}}

/* ---------- canvas ---------- */
.canvas{{position:relative;width:1080px;height:1920px;overflow:hidden;
  background:radial-gradient(120% 70% at 85% 0%,#7B88FF 0%,rgba(123,136,255,0) 60%),
             linear-gradient(165deg,#5F6FFF 0%,#5465FF 38%,#3F4CE6 72%,#2E39C2 100%)}}
.blob{{position:absolute;border-radius:50%;background:rgba(255,255,255,.07)}}
.ring{{position:absolute;border-radius:50%;border:2px solid rgba(255,255,255,.10)}}
.copy{{position:absolute;left:0;right:0;top:118px;text-align:center;color:#fff}}
.chip{{display:inline-flex;align-items:center;gap:14px;padding:10px 26px 10px 10px;border-radius:999px;
  background:rgba(255,255,255,.14);border:1.5px solid rgba(255,255,255,.22);font-size:30px;font-weight:600;letter-spacing:.3px}}
.chip img{{width:50px;height:50px;border-radius:14px}}
.h1{{margin-top:34px;font-size:86px;line-height:1.02;font-weight:700;letter-spacing:-1.6px}}
.h1 em{{font-style:normal;color:#D9DDFF}}
.sub{{margin-top:22px;font-size:34px;line-height:1.3;font-weight:400;color:rgba(255,255,255,.86)}}

/* ---------- phone ---------- */
.phone-wrap{{position:absolute;left:50%;top:528px;transform-origin:top center;transform:translateX(-50%) scale(1.45)}}
.phone{{position:relative;width:436px;height:916px;border-radius:52px;padding:12px;background:#0E0F14;
  box-shadow:0 0 0 2px #2A2C36 inset,0 0 0 1.5px #3A3D4A,0 60px 120px rgba(10,14,60,.55),0 20px 40px rgba(10,14,60,.35)}}
.phone:before{{content:"";position:absolute;right:-3px;top:190px;width:3px;height:80px;border-radius:2px;background:#24262F}}
.screen{{position:relative;width:412px;height:892px;border-radius:40px;overflow:hidden;background:{BG2}}}
.scroll{{position:absolute;inset:0}}
.punch{{position:absolute;top:9px;left:50%;width:12px;height:12px;margin-left:-6px;border-radius:50%;background:#0B0B0F;box-shadow:0 0 0 1.5px #1c1d24}}

.header{{position:absolute;left:0;top:0;width:100%;background:{BRAND};padding:0 16px 16px;
  border-radius:0 0 16px 16px;box-shadow:0 4px 8px rgba(0,0,0,.04)}}
.statusbar{{height:40px;display:flex;align-items:center;padding:0 10px 0 12px}}
.avatar{{width:40px;height:40px;border-radius:20px;background:{BG2};padding:8px;display:flex;flex:none}}
.bell{{padding:8px;border-radius:50%;background:#fff;display:flex;flex:none}}
.search{{height:48px;border-radius:12px;background:#fff;padding:0 16px;display:flex;align-items:center}}

.slider{{position:relative}}
.slide{{height:100%;border-radius:10px;overflow:hidden;box-shadow:0 5px 10px rgba(0,0,0,.1)}}
.slide img{{width:100%;height:100%;object-fit:cover;display:block}}
.indicator{{position:absolute;left:50%;bottom:16.5px;transform:translateX(-50%);display:flex;gap:4px;align-items:center;
  padding:5px 10px;border-radius:8px;background:rgba(237,237,237,.85);backdrop-filter:blur(6px)}}
.ind{{width:5px;height:5px;border-radius:50px;background:#fff}} .ind.on{{width:20px;border-radius:3px;background:{BRAND}}}

.cat-card{{background:#fff;border-radius:12px;padding:12px}}
.cat-grid{{display:flex;flex-wrap:wrap;gap:16px 24px}}
.cat-grid .cat-item{{width:calc((100% - 72px)/4)}}
.cat-item{{display:flex;flex-direction:column;align-items:center}}
.cat-circle{{width:48px;height:48px;border-radius:24px;background:{BG2};display:flex;align-items:center;justify-content:center}}

.req{{position:relative;overflow:hidden;border-radius:16px;background:{BRAND_SUBTLE}}}
.circ{{position:absolute;border-radius:50%;background:rgba(84,101,255,.1)}}
.req-btn{{padding:8px 12px;border-radius:8px;background:{BRAND};color:#fff;font-size:14px;line-height:1.25}}

.hscroll{{display:flex;flex-wrap:nowrap;overflow:hidden}}
.svc-card{{background:#fff;border-radius:12px;padding:12px;display:flex;flex-direction:column;gap:12px}}
.svc-img{{width:55px;height:72px;border-radius:4px;object-fit:cover;flex:none}}
.add-btn{{height:32px;padding:0 10px;border-radius:8px;background:{BRAND_SUBTLE};border:1px solid {BRAND};
  color:{BRAND};font-size:14px;display:flex;align-items:center;justify-content:center}}

.navbar{{position:absolute;left:0;right:0;bottom:0;background:#fff;border-radius:16px 16px 0 0;box-shadow:0 2px 16px rgba(0,0,0,.08)}}
.nav-item{{display:flex;flex-direction:column;align-items:center;gap:2px;width:20%}}
.gesture{{height:18px;display:flex;justify-content:center;align-items:flex-start}}
.gesture span{{width:108px;height:4px;border-radius:2px;background:#1A1A1A;opacity:.85}}

/* ---------- floating real components ---------- */
.float{{position:absolute;transform-origin:top left;border-radius:12px}}
.float-svc{{left:628px;top:1478px;transform:scale(1.3) rotate(-2.5deg);
  box-shadow:0 30px 60px rgba(14,20,90,.35),0 8px 18px rgba(14,20,90,.18);border-radius:12px}}
.prov-card{{width:305px;background:#fff;border-radius:12px;overflow:hidden}}
.prov-float{{position:absolute;left:12px;right:12px;bottom:-17px;background:#fff;border-radius:8px;padding:12px;
  display:flex;align-items:center;gap:12px;box-shadow:0 8px 16px rgba(0,0,0,.04)}}
.float-prov{{left:28px;top:1180px;transform:scale(1.18) rotate(2deg);
  box-shadow:0 30px 60px rgba(14,20,90,.35),0 8px 18px rgba(14,20,90,.18)}}
</style></head><body>
<div class="canvas">
  <span class="blob" style="width:520px;height:520px;right:-180px;top:-160px"></span>
  <span class="blob" style="width:380px;height:380px;left:-170px;top:820px"></span>
  <span class="ring" style="width:760px;height:760px;left:-300px;top:1240px"></span>
  <span class="ring" style="width:540px;height:540px;right:-260px;top:520px"></span>

  <div class="copy">
    <div class="chip"><img src="img/r_brand.png">Khidma Plus</div>
    <div class="h1">Home services,<br><em>right where you are</em></div>
    <div class="sub">Car wash, maids &amp; more from providers near you</div>
  </div>

  <div class="phone-wrap"><div class="phone">{screen}</div></div>

  <div class="float float-svc">{floating_service}</div>
</div>
</body></html>"""

open(os.path.join(HERE, "home.html"), "w", encoding="utf-8").write(html)
print("ok")
