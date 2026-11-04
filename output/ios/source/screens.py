"""Generates 02..08 Play Store screenshots (HTML) for the Khidma Plus customer app.
Data: live bareeq plus provider/services from admin.khidmaplus.com; the booking,
chat and request contents are sample data built on those real services."""
import json, os
from kit import *

OUT = HERE


def save(name, html):
    open(os.path.join(OUT, name + ".html"), "w", encoding="utf-8").write(html)


# ------------------------------------------------------------------ 02 provider
def provider_service_card(img, title, price, minutes, qty=0):
    """ProviderServicesContainer._serviceItem -> ServiceCard(showBorder, 80x110, showProviderName:false)."""
    action = stepper(qty) if qty else add_btn()
    return f"""
<div class="card" style="border:1px solid {BORDER};border-radius:12px;background:#fff;padding:12px;display:flex;flex-direction:column;gap:12px">
  <div class="row top" style="gap:8px">
    <img src="img/{img}" style="width:80px;height:110px;border-radius:4px;object-fit:cover;flex:none">
    <div class="col grow">
      <div class="row center"><span class="t14 w500 ell grow">{title}</span>{ic('dr_favorite', 24, ICON1)}</div>
      <div style="height:4px"></div>
      <div class="row center">
        {ic('users', 16, ICON2)}<span style="width:4px"></span><span class="t12" style="color:{TXT2}">1 Person</span>
        <span style="width:4px"></span><span class="dot"></span><span style="width:4px"></span>
        {ic('clock', 16, ICON2)}<span style="width:4px"></span><span class="t12" style="color:{TXT2}">{minutes} Minutes</span>
      </div>
    </div>
  </div>
  <div class="dash"></div>
  <div class="row center">
    <div class="col grow" style="gap:4px"><span class="t14 w600">{price}</span><div style="height:16px"></div></div>
    {action}
  </div>
</div>"""


def chip(icon, label):
    return (f'<div class="row center" style="padding:8px;border-radius:8px;background:{BG2};flex:none">'
            f'{ic(icon, 16, TXT1)}<span style="width:4px"></span><span class="t12 ell">{label}</span></div>')


def filter_chip(label, icon=None):
    i = (ic(icon, 20, TXT1) + '<span style="width:8px"></span>') if icon else ""
    return (f'<div class="row center" style="padding:8px 12px;border-radius:12px;background:{BG2};flex:none">'
            f'{i}<span class="t14">{label}</span></div>')


def screen_provider():
    banner_h = 892 * 0.27          # context.screenHeight * 0.27
    card_top = banner_h - 45       # cardOverlapAmount 45.rh
    card_h = 12 + 48 + 8 + 32 + 12
    tabs_top = banner_h + (card_h - 45) + 28 - 28 + 28   # expandedHeight bottom = tabs+filters
    tabs_top = 28 + banner_h + (card_h - 45) + 28 + 48 - 96
    tabs = "".join(
        f'<div class="col" style="flex:1;align-items:center;justify-content:center;position:relative;height:48px">'
        f'<span class="t14 {"w500" if i == 0 else ""}" style="color:{BRAND if i == 0 else TXT1};line-height:20px">{t}</span>'
        + (f'<span style="position:absolute;left:0;right:0;bottom:0;height:4px;border-radius:8px 8px 0 0;background:{BRAND}"></span>' if i == 0 else "")
        + '</div>' for i, t in enumerate(["Services", "About", "Gallery", "Review"]))
    list_top = tabs_top + 48 + 52 + 8
    return f"""
<div style="position:absolute;inset:0;background:{BG2}"></div>
<div style="position:absolute;left:0;top:0;width:412px;height:{banner_h}px;border-radius:0 0 16px 16px;overflow:hidden;border-bottom:1.5px solid {BORDER_MUTED}">
  <img src="img/s_10.jpg" style="width:100%;height:100%;object-fit:cover;display:block"></div>
<div style="position:absolute;left:0;top:0;right:0;z-index:5">{status_bar(False)}</div>
<div style="position:absolute;left:10px;top:{28 + (56 - 37.6) / 2}px" class="circle-btn">{ic('left_arrow', 24*RS, TXT1)}</div>
<div style="position:absolute;right:16px;top:{28 + (56 - 37.6) / 2}px" class="row">
  <div class="circle-btn">{ic('search', 24*RS, TXT1)}</div><span style="width:12px"></span><div class="circle-btn">{ic('menu', 24*RS, TXT1)}</div></div>

<div style="position:absolute;left:8px;top:{card_top}px;width:396px;background:#fff;border-radius:12px;padding:12px;box-shadow:0 3px 24px rgba(0,0,0,.08)">
  <div class="row top">
    <img src="img/r_prov5.jpg" style="width:48px;height:48px;border-radius:4.8px;object-fit:cover;flex:none">
    <span style="width:12px"></span>
    <div class="grow"><span class="t16 w500">bareeq plus</span></div>
    <div style="padding:8px;border-radius:8px;background:{BRAND_SUBTLE};display:flex">{ic('chat', 24, BRAND)}</div>
  </div>
  <div style="height:8px"></div>
  <div class="row" style="gap:8px;overflow:hidden">{chip('map_pin_area', '25 km Distance')}{chip('users', 'organization')}{chip('store_outline', 'Doorstep Allowed')}</div>
</div>

<div style="position:absolute;left:0;right:0;top:{tabs_top}px;background:#fff;z-index:4">
  <div class="row" style="padding:0 16px;border-bottom:1.5px solid {BORDER_MUTED}">{tabs}</div>
  <div class="row" style="padding:8px 16px;gap:8px;box-shadow:0 8px 16px rgba(0,0,0,.04);background:#fff">
    {filter_chip('Filter', 'sort_filter')}{filter_chip('Top Rated')}{filter_chip('Doorstep')}{filter_chip('Pay Later')}</div>
</div>

<div style="position:absolute;left:0;right:0;top:{list_top}px;bottom:0;background:#fff;padding:12px 16px 0">
  <div class="row center"><span class="t16 w700 grow">salon (5)</span>{ic('down_arrow', 24, ICON1, 'transform:rotate(180deg)')}</div>
  <div style="height:12px"></div>
  <div class="col" style="gap:12px">
    {provider_service_card('s_19.jpg', 'normal wash salon', 'AED75', 30, qty=1)}
    {provider_service_card('s_17.jpg', 'silver wash salon', 'AED80', 40)}
    {provider_service_card('s_15.jpg', 'golden wash salon', 'AED120', 60)}
  </div>
</div>
{cart_bar(['s_19.jpg'], 1, 'AED75')}
{gesture()}"""


# ------------------------------------------------------------------ 03 service details
def screen_service():
    w = 412 - 32
    gh = w * 336 / 352
    main_w = (w - 12) * 260 / 340
    side_w = (w - 12) * 80 / 340
    share = f'<div style="margin-right:8px;padding:8px;border-radius:50%;background:#fff;display:flex">{ic("dr_share", 24, ICON1)}</div>'
    bullets = "".join(f'<li>{t}</li>' for t in ["Full deep interior cleaning", "Exterior car wash", "Car perfume", "Seat wrapping/protection"])
    return f"""
<div style="position:absolute;inset:0;background:#fff"></div>
{simple_app_bar('<span class="t16 w500">Service Details</span>', share)}
<div style="position:absolute;left:0;right:0;top:84px;padding:16px">
  <div class="row" style="height:{gh}px;gap:12px">
    <img src="img/s_12.jpg" style="width:{main_w}px;height:100%;border-radius:8px;object-fit:cover">
    <img src="img/s_12_other.jpg" style="width:{side_w}px;height:100%;border-radius:8px;object-fit:cover">
  </div>
  <div style="height:12px"></div>
  <div style="height:8px"></div>
  <div class="t16 w700">deep wash salon</div>
  <div style="height:8px"></div>
  <div class="row center">
    {ic('users', 20, ICON1)}<span style="width:4px"></span><span class="t14">1 Person</span>
    <span style="width:8px"></span><span style="width:1px;height:10px;background:{TXT1}"></span><span style="width:8px"></span>
    {ic('clock', 20, ICON1)}<span style="width:4px"></span><span class="t14">90 Minutes</span>
  </div>
  <div style="height:10px"></div>
  <div class="row center" style="background:{BG2};border-radius:8px;padding:12px">
    {ic('verified', 16, BRAND)}<span style="width:4px"></span><span class="t12">Doorstep Allowed</span><span style="width:12px"></span>
    {ic('verified', 16, BRAND)}<span style="width:4px"></span><span class="t12">Cancellable Allowed</span>
  </div>
  <div style="height:12px"></div>
  <div class="row center"><span class="t24 w700 grow">AED249</span>{stepper(1, height=40, pad=8, icon=24, count=16)}</div>
  <div style="height:16px"></div><div class="dash"></div><div style="height:16px"></div>
  <div class="t16 w600">About Service</div>
  <ul class="t12" style="color:{TXT2};padding-left:24px;margin-top:12px;line-height:1.5">{bullets}</ul>
  <div style="height:16px"></div><div class="dash"></div><div style="height:16px"></div>
  <div class="t16 w600">Provider</div>
  <div style="height:12px"></div>
  <div class="row center"><img src="img/r_prov5.jpg" style="width:64px;height:64px;border-radius:12px;object-fit:cover">
    <span style="width:12px"></span><div class="col" style="gap:4px"><span class="t14 w600">bareeq plus</span>
    <div class="row center">{ic('map_pin_area', 14, ICON2)}<span style="width:4px"></span><span class="t12" style="color:{TXT2}">25 km</span></div></div></div>
</div>
{cart_bar(['s_12.jpg'], 1, 'AED249')}
{gesture()}"""


# ------------------------------------------------------------------ 04 checkout
def screen_checkout():
    title = ('<div class="col"><span class="t16 w700">bareeq plus</span><div style="height:2px"></div>'
             f'<div class="row center"><span class="t12" style="color:{TXT2}">1 service</span><span style="width:6px"></span>'
             f'<span style="width:4px;height:4px;border-radius:50%;background:{TXT3}"></span><span style="width:6px"></span>'
             f'<span class="t12" style="color:{TXT2}">AED249</span></div></div>')
    check = (f'<div style="width:18px;height:18px;margin:3px;border-radius:5px;border:1px solid {BRAND};background:{BG2};display:flex;align-items:center;justify-content:center">'
             f'<svg width="14" height="14" viewBox="0 0 24 24"><path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z" fill="{BRAND}"/></svg></div>')
    pill = lambda icon, label: (f'<div class="row center" style="padding:8px 12px;border-radius:12px;background:{BG2};border:1px solid {BORDER}">'
                                f'{ic(icon, 16, ICON1)}<span style="width:8px"></span><span class="t12">{label}</span></div>')
    return f"""
{simple_app_bar(title)}
<div style="position:absolute;left:0;right:0;top:84px">
  <div style="background:#fff;padding:12px 16px">
    <span class="t12" style="color:{TXT2}">Service Location</span><div style="height:4px"></div>
    <div class="row center"><span class="t12 w500">Villa 12, Al Markaziyah, Abu Dhabi</span><span style="width:4px"></span>{ic('down_arrow', 16, ICON1)}</div>
    <div style="height:12px"></div>
    <div class="row center">{check}<span style="width:8px"></span><span class="t12" style="color:{TXT2}">Billing address is same as service address</span></div>
  </div>
  <div style="padding:16px">
    <div style="background:#fff;border-radius:12px;padding:12px">
      <div class="row center">
        <img src="img/s_12.jpg" style="width:44px;height:44px;border-radius:8.8px;object-fit:cover">
        <span style="width:12px"></span>
        <div class="col grow"><span class="t12 w500">deep wash salon</span><div style="height:4px"></div><span class="t12">AED249</span></div>
        <span style="width:10px"></span>{stepper(1, height=32, pad=8, icon=16, count=14)}
      </div>
      <div style="height:12px"></div>
      <div class="row" style="gap:8px">{pill('plus', 'Add More Item')}{pill('edit', 'Write Instruction')}</div>
    </div>
  </div>
  <div style="padding:0 16px">
    <div style="background:#fff;border-radius:12px;padding:12px">
      <div class="row center">
        <div style="padding:8px;border-radius:12px;background:{BG2};display:flex">{ic('calendar', 16, ICON1)}</div><span style="width:8px"></span>
        <span class="t14 w500 grow">Select date &amp; Time</span>
        <div class="row center" style="padding:4px"><span class="t14" style="color:{BRAND}">View All</span><span style="width:4px"></span>{ic('back_arrow_ltr', 20, BRAND)}</div>
      </div>
      <div style="height:12px"></div><div class="divider"></div><div style="height:12px"></div>
      <div style="display:inline-block;padding:8px;border-radius:8px;background:{BG2};border:1px solid {BORDER}"><span class="t12">30/10/2026, 10:00 AM</span></div>
    </div>
  </div>
  <div style="padding:16px 16px 0">
    <div style="background:#fff;border-radius:12px;padding:12px">
      <div class="row center"><span class="t14 w500 grow">Bill Details</span></div>
      <div style="height:12px"></div><div class="divider"></div><div style="height:12px"></div>
      <div class="col" style="gap:10px">
        <div class="row"><span class="t14 grow" style="color:{TXT2}">Item Total</span><span class="t14">AED249</span></div>
      </div>
      <div style="height:12px"></div><div class="dash"></div><div style="height:12px"></div>
      <div class="row center">
        <div style="padding:8px;border-radius:12px;background:{BG2};display:flex">{ic('file_text', 16, ICON1)}</div><span style="width:8px"></span>
        <span class="t14 grow">Total Bill <b class="w600">AED249</b></span>
      </div>
    </div>
  </div>
</div>
<div style="position:absolute;left:0;right:0;bottom:18px;background:#fff;padding:16px;box-shadow:0 -4px 24px rgba(0,0,0,.08);z-index:20">
  <div class="btn">Book Services</div></div>
{gesture()}"""


# ------------------------------------------------------------------ 05 booking details
STATUS = {  # BookingStatusChip.colorsFor
    "on_the_way": ("#FEE7E1", "#ED3608", "On The Way"),
    "started": ("#E7F4FE", "#2196F3", "Started"),
    "confirmed": (BRAND_SUBTLE, BRAND, "Confirmed"),
    "completed": (SUCCESS_SUBTLE, SUCCESS, "Completed"),
}


def status_chip(s):
    bg, fg, label = STATUS[s]
    return f'<div style="padding:8px;border-radius:8px;background:{bg};flex:none"><span class="t12 w500" style="color:{fg}">{label}</span></div>'


def box(inner, pad=12):
    return f'<div style="background:#fff;border-radius:12px;padding:{pad}px">{inner}</div>'


def card_head(title):
    return (f'<span class="t14 w500">{title}</span><div style="height:12px"></div>'
            f'<div class="divider"></div><div style="height:12px"></div>')


def screen_booking_details(cust, prov):
    (cx, cy), (px_, py_) = cust, prov
    icon_row = lambda icon, text: (f'<div class="row center grow" style="gap:4px">{ic(icon, 20, ICON1)}'
                                   f'<span class="t14 ell">{text}</span></div>')
    summary = box(f"""
  <div class="row top"><div class="col grow" style="gap:4px"><span class="t12" style="color:{TXT2}">Invoice No</span>
    <span class="t12 w500">#2041</span></div>{status_chip('on_the_way')}</div>
  <div style="height:12px"></div><div class="divider"></div><div style="height:16px"></div>
  <div class="row center" style="display:inline-flex;gap:4px;padding:4px 8px;border-radius:8px;background:{BRAND_SUBTLE}">
    <span class="t12">OTP</span><span class="t14 w500">4827</span></div>
  <div style="height:16px"></div>
  <div class="row center">{icon_row('calendar', '30/10/2026')}{icon_row('clock', '10:00 AM To 11:30 AM')}</div>
  <div style="height:12px"></div>
  <div class="row top">{ic('map_pin_area', 20, ICON1)}<span style="width:8px"></span>
    <div class="col" style="gap:4px"><span class="t11" style="color:{BRAND}">At Doorstep</span>
    <span class="t12 w500">Villa 12, Al Markaziyah, Abu Dhabi</span></div></div>""")
    track = box(card_head("Track Provider") + f"""
  <div style="position:relative;height:180px;border-radius:12px;overflow:hidden">
    <img src="img/minimap.jpg" style="position:absolute;left:0;top:0;width:368px;height:180px">
    <svg style="position:absolute;left:0;top:0" width="368" height="180">
      <line x1="{px_}" y1="{py_}" x2="{cx}" y2="{cy}" stroke="#2196F3" stroke-width="3" stroke-linecap="round"/></svg>
    <div style="position:absolute;left:{cx-18}px;top:{cy-36}px">{ic('customer_pin', 36, BRAND)}</div>
    <div style="position:absolute;left:{px_-18}px;top:{py_-18}px">{ic('handyman', 36, BRAND)}</div>
    <div style="position:absolute;right:8px;top:8px;padding:8px;border-radius:100px;background:#1A1A1A;display:flex">{ic('arrows_out_simple', 24, '#fff')}</div>
    <div style="position:absolute;left:4px;bottom:3px;font-size:7px;color:#555;background:rgba(255,255,255,.7);padding:0 3px;border-radius:2px">Esri, HERE, Garmin, © OpenStreetMap</div>
  </div>""")
    bg, fg, _ = STATUS["on_the_way"]
    status_row = box(f"""<div class="row center">
  <div style="padding:8px;border-radius:72px;background:{bg};display:flex">{ic('check_circle_fill', 16, fg)}</div><span style="width:8px"></span>
  <div class="col grow" style="gap:4px"><span class="t14 w500">Provider On the Way</span>
    <span class="t12" style="color:{TXT2}">30/10/2026, 09:38 AM</span></div>
  <div style="padding:8px;border-radius:24px;background:{BG2};display:flex">{mat('chevron_right', 20, ICON1)}</div></div>""")
    services = box(card_head("Services (1)") + f"""<div class="row top">
  <img src="img/s_12.jpg" style="width:44px;height:44px;border-radius:8.8px;object-fit:cover"><span style="width:12px"></span>
  <div class="col"><span class="t12 w500">deep wash salon</span><div style="height:4px"></div>
    <span class="t12" style="color:{BRAND}">salon</span><div style="height:8px"></div>
    <div class="row center"><span class="t12">1 Qty</span><span style="width:8px"></span><span style="width:1px;height:12px;background:#000"></span>
    <span style="width:8px"></span><span class="t12">AED249</span></div></div></div>""")
    team = box(card_head("Service Team") + f"""<div class="row top">
  <img src="img/r_prov5.jpg" style="width:64px;height:64px;border-radius:12.8px;object-fit:cover"><span style="width:12px"></span>
  <div class="col grow"><div class="row top"><div class="col grow"><span class="t12 w500">bareeq plus</span></div>
    <div style="padding:8px;border-radius:8px;background:{BRAND_SUBTLE};display:flex">{ic('chat', 20, BRAND)}</div></div></div></div>""")
    return f"""
{simple_app_bar('<span class="t16 w500">Booking Details</span>')}
<div class="col" style="position:absolute;left:10px;right:10px;top:{84+16}px;gap:16px">
  {summary}{track}{status_row}{services}{team}
</div>
{gesture('transparent')}"""


# ------------------------------------------------------------------ 06 my bookings
def provider_line(chat_pad=4, chat_icon=20, trailing=None):
    btn = trailing or (f'<div style="padding:{chat_pad}px;border-radius:8px;background:{BRAND_SUBTLE};display:flex">'
                       f'{ic("chat", chat_icon, BRAND)}</div>')
    return f"""<div class="row center">
  <img src="img/r_prov5.jpg" style="width:32px;height:32px;border-radius:6.4px;object-fit:cover"><span style="width:8px"></span>
  <div class="col grow" style="gap:4px"><span class="t12" style="color:{TXT2}">Provider</span><span class="t12">bareeq plus</span></div>
  <span style="width:8px"></span>{btn}</div>"""


def ongoing_card(when, status, service):
    return f"""<div style="width:300px;flex:none;background:#fff;border-radius:12px;padding:12px">
  <div class="row top"><div class="col grow" style="gap:4px"><span class="t12" style="color:{TXT2}">Date and Time</span>
    <span class="t12">{when}</span></div><span style="width:8px"></span>{status_chip(status)}</div>
  <div style="height:16px"></div><span class="t14">{service}</span>
  <div style="height:12px"></div><div class="dash"></div><div style="height:12px"></div>
  {provider_line()}</div>"""


def booking_card(no, status, service, total, date, time, completed=False):
    rebook = f'<div style="padding:8px 12px;border-radius:8px;background:{BRAND}"><span class="t14" style="color:#fff">Re-book</span></div>'
    return f"""<div style="background:#fff;border-radius:12px;padding:12px;margin-bottom:12px">
  <div class="row top"><div class="col grow" style="gap:4px"><span class="t12" style="color:{TXT2}">Invoice No</span>
    <span class="t12">#{no}</span></div><span style="width:12px"></span>{status_chip(status)}</div>
  <div style="height:12px"></div><span class="t14">{service}</span><div style="height:12px"></div>
  <div class="row center"><span class="t16 w500">{total}</span><span style="width:12px"></span>
    <span style="width:1px;height:16px;background:{BORDER}"></span><span style="width:12px"></span>
    {ic('calendar', 16, ICON2)}<span style="width:4px"></span><span class="t12" style="color:{TXT2}">{date}</span><span style="width:8px"></span>
    {ic('clock', 16, ICON2)}<span style="width:4px"></span><span class="t12" style="color:{TXT2}">{time}</span></div>
  <div style="height:12px"></div><div class="dash"></div><div style="height:12px"></div>
  {provider_line(8, 24, rebook if completed else None)}</div>"""


def section_head(title):
    return f'<div class="row center" style="margin-bottom:8px"><span class="t16 w500 grow">{title}</span>{mat("keyboard_arrow_up", 24, TXT1)}</div>'


def nav_item(icon, label, active=False):
    if active:
        icon_html = f'<div style="padding:4px 8px;border-radius:16px;background:{BRAND_SUBTLE};display:flex">{ic(icon, 24, BRAND)}</div>'
        lab = f'<span class="t12 w600" style="color:{BRAND};line-height:18px">{label}</span>'
    else:
        icon_html = f'<div style="padding:4px;display:flex">{ic(icon, 24, ICON2)}</div>'
        lab = f'<span class="t12" style="color:{TXT2};line-height:18px">{label}</span>'
    return f'<div class="col center" style="gap:2px;width:20%">{icon_html}{lab}</div>'


def screen_bookings():
    tabs = "".join(
        f'<div class="col" style="flex:1;align-items:center;justify-content:center;position:relative;height:48px">'
        f'<span class="t14 {"w500" if i == 0 else ""}" style="color:{BRAND if i == 0 else TXT1};line-height:20px">{t}</span>'
        + (f'<span style="position:absolute;left:12px;right:12px;bottom:0;height:4px;border-radius:8px 8px 0 0;background:{BRAND}"></span>' if i == 0 else "")
        + '</div>' for i, t in enumerate(["General Booking", "Custom Booking"]))
    chips = "".join(
        f'<div style="flex:none;padding:8px 12px;border-radius:12px;background:{BRAND_SUBTLE if i == 0 else BG2};'
        f'border:1px solid {BRAND if i == 0 else "transparent"}">'
        f'<span class="t14" style="color:{BRAND if i == 0 else TXT1}">{c}</span></div>'
        for i, c in enumerate(["All", "Awaiting", "Confirmed", "On The Way", "Arrived", "Started"]))
    ongoing = "".join([
        ongoing_card("30/10/2026, 10:00 AM", "on_the_way", "deep wash salon"),
        '<span style="width:12px;flex:none"></span>',
        ongoing_card("30/10/2026, 08:30 AM", "started", "steam wash salon"),
    ])
    return f"""
<div class="appbar" style="box-shadow:0 8px 16px rgba(0,0,0,.04)">
  {status_bar(True)}
  <div class="row center" style="height:56px;padding-left:16px"><span class="t16 w500">My Bookings</span></div>
  <div class="row" style="padding:0 16px;border-bottom:1.5px solid {BORDER_MUTED}">{tabs}</div>
  <div class="row" style="padding:16px;gap:8px;overflow:hidden">{chips}</div>
</div>
<div style="position:absolute;left:10px;right:0;top:{84+48+1.5+68+16}px">
  {section_head('Ongoing Booking')}
  <div class="row" style="overflow:hidden;margin-bottom:16px">{ongoing}</div>
  <div style="margin-right:10px">
  {section_head('Upcoming Booking')}
  {booking_card(2056, 'confirmed', 'golden wash salon', 'AED120', '02/11/2026', '11:00 AM')}
  <div style="height:4px"></div>
  {section_head('Completed Booking')}
  {booking_card(2017, 'completed', 'silver wash salon', 'AED80', '24/10/2026', '04:00 PM', completed=True)}
  </div>
</div>
<div style="position:absolute;left:0;right:0;bottom:0;background:#fff;border-radius:16px 16px 0 0;box-shadow:0 2px 16px rgba(0,0,0,.08);z-index:20">
  <div class="row" style="justify-content:space-around;padding:8px 4px">
    {nav_item('inactive_explore', 'Explore')}{nav_item('active_booking', 'Bookings', True)}
    {nav_item('inactive_chat', 'Chat')}{nav_item('inactive_my_req', 'Requests')}{nav_item('inactive_profile', 'Profile')}
  </div>
  <div style="height:18px;display:flex;justify-content:center"><span style="width:108px;height:4px;border-radius:2px;background:#1A1A1A;opacity:.85"></span></div>
</div>"""


# ------------------------------------------------------------------ 07 chat
def bubble(text, time, me):
    bg = BRAND_SUBTLE if me else "#fff"
    jus = "flex-end" if me else "flex-start"
    return f"""<div class="row" style="justify-content:{jus};margin:4px 0">
  <div style="max-width:{(412-16)*0.8}px;min-width:{(412-16)*0.15}px;background:{bg};border-radius:8px;padding:8px;display:flex;flex-direction:column;gap:8px">
    <span style="font-size:14px;line-height:1.35">{text}</span>
    <span class="t12" style="align-self:flex-end">{time}</span></div></div>"""


def screen_chat():
    head = (f'<div class="row center"><img src="img/r_prov5.jpg" style="width:44px;height:44px;border-radius:50%;object-fit:cover">'
            f'<span style="width:12px"></span><div class="col"><span class="t16 w500">bareeq plus</span>'
            f'<span class="t12" style="color:{BRAND}"># 2041</span></div></div>')
    menu = f'<div style="padding:12px">{mat("more_vert", 24, ICON1)}</div>'
    msgs = "".join([
        bubble("Hi! I booked the deep wash salon for tomorrow at 10:00 AM. The car is at Villa 12, Al Markaziyah.", "09:12 AM", True),
        bubble("Hello, thank you for booking with bareeq plus. Our team will be there at 10:00 AM.", "09:14 AM", False),
        bubble("Could you please park the car in a shaded spot? We bring our own water and steam equipment.", "09:14 AM", False),
        bubble("Sure, it will be in the driveway. Is seat protection included?", "09:16 AM", True),
        bubble("Yes. Deep interior cleaning, exterior wash, car perfume and seat wrapping are all included.", "09:17 AM", False),
        bubble("Perfect, see you tomorrow!", "09:18 AM", True),
    ])
    return f"""
<div class="appbar" style="border-bottom:1.5px solid {BORDER}">
  {status_bar(True)}
  <div class="row center" style="height:{892*0.08:.1f}px">{back_arrow()}<div class="grow">{head}</div>{menu}</div>
</div>
<div style="position:absolute;left:0;right:0;top:{28+892*0.08+1.5}px;padding:8px 8px 0">
  <div class="row" style="justify-content:center;padding:8px 0"><span class="t12" style="background:{BG3};border-radius:16px;padding:6px 14px">Today</span></div>
  {msgs}
</div>
<div style="position:absolute;left:0;right:0;bottom:0;background:#fff;border-radius:8px 8px 0 0;padding:16px 16px {16+18}px;z-index:20">
  <div class="row center" style="gap:12px">
    <div class="row center grow" style="background:{BG2};border-radius:8px;padding:12px;gap:12px">
      <span class="t12 grow" style="color:{TXT3}">Type Message..</span>{mat('add', 24, ICON1)}</div>
    <div style="padding:8px;border-radius:48px;background:{BRAND};display:flex">{ic('send_message', 32*RS, '#fff')}</div>
  </div>
</div>
{gesture()}"""


# ------------------------------------------------------------------ 08 request service
def field(label, value, multiline=False, required=True):
    star = f'<span style="font-size:14px;color:#D63031">*</span>' if required else ""
    h = "min-height:96px;" if multiline else ""
    return f"""<div class="col" style="gap:6px">
  <div class="row center" style="gap:2px"><span class="t12">{label}</span>{star}</div>
  <div style="border:0.5px solid {BORDER};border-radius:8px;padding:12px;background:#fff;{h}"><span class="t14" style="line-height:1.4">{value}</span></div></div>"""


def card(title, body, trailing=""):
    return f"""<div style="background:#fff;border-radius:12px;padding:16px">
  <div class="row center"><span class="t14 w500 grow">{title}</span>{trailing}</div>
  <div style="height:8px"></div><div style="height:1px;background:{BORDER_MUTED}"></div><div style="height:8px"></div>
  {body}</div>"""


def screen_request():
    step = lambda icon, color, bg, border: (f'<div style="padding:8px;border-radius:24px;background:{bg};{border}display:flex">{ic(icon, 16, color)}</div>')
    stepper_bar = f"""<div class="row center" style="padding:8px 12px 16px;background:#fff;box-shadow:0 8px 16px rgba(0,0,0,.04)">
  {step('squares_four', SUCCESS, SUCCESS_SUBTLE, '')}<span style="width:8px"></span>
  <div class="col"><span class="t12" style="color:{TXT2}">STEP 1</span><div style="height:4px"></div><span class="t12 w500">Categories</span></div>
  <span style="width:4px"></span><div class="grow row" style="justify-content:center"><div class="dash" style="max-width:60px;background:repeating-linear-gradient(90deg,#EDEDED 0 4px,transparent 4px 8px)"></div></div><span style="width:4px"></span>
  {step('service', BRAND, BRAND_SUBTLE, f'border:1px solid {BRAND};')}<span style="width:8px"></span>
  <div class="col"><span class="t12" style="color:{TXT2}">STEP 2</span><div style="height:4px"></div><span class="t12 w500">Request Details</span></div>
</div>"""
    cats = (f'<div class="row center" style="gap:4px"><span class="t14">Car wash</span>{ic("back_arrow_ltr", 16, ICON1)}<span class="t14">4x4</span></div>')
    return f"""
<div class="appbar">{status_bar(True)}<div class="row center" style="height:56px">{back_arrow()}<span class="t16 w500 grow">Request Service</span></div>{stepper_bar}</div>
<div style="position:absolute;left:0;right:0;top:{84+70}px;padding:16px" class="col">
  {card('Selected Categories', cats, ic('edit', 20, ICON1))}
  <div style="height:12px"></div>
  {card('Service Description', '<div class="col" style="gap:12px">' + field('Service Title', 'Ceramic coating for SUV') + field('Description', 'Ceramic coating and full interior detailing for a 2022 Toyota Land Cruiser. The car is parked at home in Al Markaziyah.', True) + '</div>')}
  <div style="height:12px"></div>
  {card('Preferred Budget', '<div class="row" style="gap:12px"><div class="grow">' + field('Min', 'AED 400') + '</div><div class="grow">' + field('Max', 'AED 900') + '</div></div>')}
  <div style="height:12px"></div>
  {card('Request Duration', field('Start At', '31/10/2026, 09:00 AM'))}
</div>
<div style="position:absolute;left:0;right:0;bottom:18px;background:#fff;padding:16px;box-shadow:0 -4px 24px rgba(0,0,0,.08);z-index:20"><div class="btn">Submit Request</div></div>
{gesture()}"""


if __name__ == "__main__":
    import sys
    cust = (float(sys.argv[1]), float(sys.argv[2])) if len(sys.argv) > 4 else (87.3, 68.6)
    prov = (float(sys.argv[3]), float(sys.argv[4])) if len(sys.argv) > 4 else (280.7, 145.4)
    save("02_provider", page('See every provider<br><em>before you book</em>', 'Services, prices &amp; distance at a glance', screen_provider(), deco=1))
    save("03_service", page('Know exactly<br><em>what you get</em>', 'Clear prices, duration &amp; what’s included', screen_service(), screen_bg="#fff"))
    save("04_checkout", page('Pick a time<br><em>that suits you</em>', 'Choose your address, date &amp; time in seconds', screen_checkout(), deco=1))
    save("05_booking", page('Track your<br><em>provider live</em>', 'Live location, OTP &amp; status for every booking', screen_booking_details(cust, prov)))
    save("06_bookings", page('All your bookings<br><em>in one place</em>', 'Ongoing, upcoming &amp; past bookings at a glance', screen_bookings(), deco=1))
    save("07_chat", page('Chat directly<br><em>with your provider</em>', 'Share details and stay in the loop', screen_chat()))
    save("08_request", page('Can’t find it?<br><em>Just request it</em>', 'Describe the job and get offers from providers', screen_request(), deco=1))
    print("ok")
