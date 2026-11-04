"""Generates the 01..08 Play Store screenshots (HTML) for the Khidma Provider app.
Provider: the live "bareeq plus" store and its services (same data as the customer
set); bookings #2041 / #2056, the chat and the "Ceramic coating for SUV" job request
are the other side of the customer screenshots. Remaining figures are sample data."""
import os
from kit import *

OUT = HERE


def save(name, html):
    open(os.path.join(OUT, name + ".html"), "w", encoding="utf-8").write(html)


def divider(margin=7.5):
    """CustomDivider / Divider(thickness .2-.5): 16px tall with a centred hairline."""
    return f'<div class="hr" style="margin:{margin}px 0"></div>'


# ------------------------------------------------------------------ BookingCardContainer
def booking_card(b, home=False):
    st = STATUS[b["status"]]
    if b["status"] == "awaiting":
        actions = (f'<div class="sq" style="width:36px;height:36px;padding:5px;background:rgba(244,67,54,.1)">{ic("close", 26, RED)}</div>'
                   f'<span style="width:10px"></span>'
                   f'<div class="sq" style="width:36px;height:36px;padding:5px;background:rgba(76,175,80,.1)">{ic("check", 26, GREEN)}</div>')
    else:
        actions = (f'<div class="sq" style="width:36px;height:36px;background:{ACC10}">{ic("dr_chat", 16, ACC)}</div>'
                   f'<span style="width:10px"></span>'
                   f'<div class="sq" style="width:36px;height:36px;background:{ACC10}">{mat("call", 24, ACC)}</div>')
    services = "".join(f'<div class="t14 w500 ell" style="padding-top:8px">{s}</div>' for s in b["services"])
    spacer = '<div class="grow"></div>' if home else ""
    h = "height:100%;" if home else ""
    return f"""<div class="card col" style="padding:10px;border:1px solid {HAIR};{h}">
  <div class="row center">
    <div class="row center grow"><span class="t14">Invoice No:</span><span style="width:5px"></span><span class="t14" style="color:{ACC}">{b['no']}</span></div>
    <div class="row center"><span class="t14" style="color:{st}">{b['label']}</span><span style="width:5px"></span>{ic('arrow_next', 16, GREY)}</div>
  </div>
  {divider()}
  <div class="row center">{ic('map_pic', 16, ACC)}<span style="width:5px"></span><span class="t14 ell grow">{b['address']}</span></div>
  <div style="height:8px"></div>
  <div class="row center">{ic('b_calender', 16, ACC)}<span style="width:5px"></span><span class="t14 w600">{b['date']}</span>
    <span style="width:8px"></span><span style="width:1px;height:18px;background:{HAIR}"></span><span style="width:8px"></span>
    {ic('b_clock', 16, ACC)}<span style="width:5px"></span><span class="t14 w600">{b['time']}</span></div>
  {services}{spacer}
  <div style="height:8px"></div>
  <span class="t20 w700">{b['total']}</span>
  {divider()}
  <div class="row center">
    <div class="col grow"><span class="t12" style="color:{GREY}">Customer</span><div style="height:5px"></div>
      <span class="t16 w600 ell">{b['customer']}</span></div>{actions}</div>
</div>"""


B_NEW = dict(no="#2058", status="awaiting", label="Awaiting", address="Villa 7, Khalifa City, Abu Dhabi",
             date="31/10/2026", time="09:00 AM", services=["steam wash 4x4"], total="AED500", customer="Omar Khalid")
B_2041 = dict(no="#2041", status="on_the_way", label="On The Way", address="Villa 12, Al Markaziyah, Abu Dhabi",
              date="30/10/2026", time="10:00 AM", services=["deep wash salon"], total="AED249", customer="Ahmed Al Mansoori")
B_2056 = dict(no="#2056", status="confirmed", label="Confirmed", address="Villa 12, Al Markaziyah, Abu Dhabi",
              date="02/11/2026", time="11:00 AM", services=["golden wash salon"], total="AED120", customer="Ahmed Al Mansoori")
B_2049 = dict(no="#2049", status="awaiting", label="Awaiting", address="Al Reem Island, Abu Dhabi",
              date="31/10/2026", time="04:00 PM", services=["silver wash salon", "normal wash salon"], total="AED155",
              customer="Fatima Hassan")


# ------------------------------------------------------------------ 01 home dashboard
def bar_chart(values, months, w=362, h=288):
    """MonthlyEarningBarChart -> fl_chart BarChart (left 40 / bottom 48 reserved)."""
    left, bottom = 48, 48
    pw, ph = w - left, h - bottom
    mx = max(values)
    maxy = mx * 1.2
    bw = 412 * 0.7 / max(len(values), 3)
    gap = (pw - bw * len(values)) / (len(values) + 1)
    grads = [("#81C784", "#4CAF50"), ("#64B5F6", "#2196F3"), ("#BA68C8", "#9C27B0")]
    defs = "".join(f'<linearGradient id="g{i}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="{a}"/><stop offset="1" stop-color="{b}"/></linearGradient>'
                   for i, (a, b) in enumerate(grads))
    out = [f'<rect x="{left}" y="0" width="{pw}" height="{ph}" fill="{BG}"/>']
    step = mx / 4
    v = 0.0
    while v <= maxy + 0.01:
        y = ph - v / maxy * ph
        if 0 < v:
            out.append(f'<line x1="{left}" x2="{w}" y1="{y:.1f}" y2="{y:.1f}" stroke="#607D8B" stroke-width=".4" stroke-dasharray="8 4"/>')
        out.append(f'<text x="{left-6}" y="{y+3.5:.1f}" font-size="10" text-anchor="end" fill="{TXT}">{v:.1f}</text>')
        v += step
    for i, (val, m) in enumerate(zip(values, months)):
        x = left + gap + i * (bw + gap)
        bh = val / maxy * ph
        y = ph - bh
        r = 5
        out.append(f'<path d="M{x:.1f},{ph} V{y+r:.1f} Q{x:.1f},{y:.1f} {x+r:.1f},{y:.1f} H{x+bw-r:.1f} Q{x+bw:.1f},{y:.1f} {x+bw:.1f},{y+r:.1f} V{ph} Z" fill="url(#g{i % 3})"/>')
        out.append(f'<text x="{x+bw/2:.1f}" y="{ph+22}" font-size="12" font-weight="700" text-anchor="middle" fill="{TXT}">{m}</text>')
    out.append(f'<rect x="{left}" y=".5" width="{pw-.5}" height="{ph-.5}" fill="none" stroke="{TXT}" stroke-width="1"/>')
    return f'<svg width="{w}" height="{h}" style="display:block;font-family:Outfit"><defs>{defs}</defs>{"".join(out)}</svg>'


def screen_home():
    def box(n, label):
        return (f'<div class="card grow" style="padding:12px;border:.5px solid {HAIR}">'
                f'<div class="t14" style="color:{ACC}">{n}</div><div class="t12" style="color:{GREY}">{label}</div></div>')

    def earn(t, v):
        return f'<div class="col"><span class="t14 ell" style="color:{ACC}">{t}</span><div style="height:4px"></div><span class="t18 w600">{v}</span></div>'

    chart = bar_chart([6200, 7400, 5900, 8800, 9600, 11800], ["May", "Jun", "Jul", "Aug", "Sep", "Oct"])
    return f"""
<div style="position:absolute;left:0;right:0;top:0;z-index:6;background:{BG}">{status_bar(BG)}
  <div class="col center" style="height:80px;justify-content:space-around;padding:6px 0">
    <span class="w700" style="font-size:22px;line-height:1.2">bareeq plus</span>
    <div class="row center">{ic('b_calender', 16, ACC)}<span style="width:5px"></span><span class="t16" style="color:{GREY}">Friday 30 October</span></div>
    <div style="height:1px"></div>
  </div></div>
<div style="position:absolute;left:0;right:0;top:{P['sb']+80}px;padding-top:20px">
  <div style="padding:0 15px"><div class="row center" style="background:{ACC};border-radius:10px;padding:15px">
    <div style="padding:10px;border-radius:10px;background:rgba(255,255,255,.2);display:flex">{ic('crown', 24, '#fff')}</div>
    <span style="width:10px"></span>
    <div class="col grow"><span class="t18 w600" style="color:#fff">Premium Partner</span><div style="height:5px"></div>
      <div class="row center"><span class="t12 grow" style="color:rgba(255,255,255,.6)">Valid till 30 Jan 2027</span>
        <span class="t14 w500" style="color:#fff">92 Days left</span></div></div>
  </div></div>
  <div class="t18 w600" style="padding:0 15px;line-height:36px">Bookings</div>
  <div class="row" style="padding:0 15px;gap:5px">{box(4, 'Todays')}{box(6, 'Tomorrow')}{box(11, 'Upcoming')}</div>
  <div style="height:10px"></div>
  <div style="padding:15px 15px 0"><div style="background:#fff;border-radius:5px;padding:10px;height:375px">
    <div class="row" style="justify-content:flex-end"><div class="row center" style="width:130px;height:30px;padding:0 6px 0 20px;border-radius:5px;background:{ACC20}">
      <span class="t16 w700 grow" style="color:{ACC}">Month</span>{mat('arrow_drop_down', 24, ACC)}</div></div>
    <div style="height:25px"></div>{chart}
  </div></div>
  <div style="height:10px"></div>
  <div class="t18 w600" style="padding:0 15px">Earning Report</div>
  <div style="height:8px"></div>
  <div style="padding:0 15px"><div class="card" style="padding:15px;border:.5px solid {HAIR};display:grid;grid-template-columns:1fr 1fr;row-gap:10px">
    {earn('My Income', 'AED18,640')}{earn('Remaining Income', 'AED4,860')}{earn('Admin Commission', 'AED2,796')}{earn('Future Earning', 'AED1,369')}
  </div></div>
</div>
{nav_bar(0)}"""


# ------------------------------------------------------------------ 02 bookings
def screen_bookings():
    chips = "".join(
        f'<div style="flex:none;min-width:90px;margin:10px;padding:0 12px;border-radius:10px;display:flex;align-items:center;justify-content:center;'
        f'background:{ACC if i == 0 else "transparent"}"><span class="t14 w700" style="color:{"#fff" if i == 0 else TXT}">{c}</span></div>'
        for i, c in enumerate(["All", "Awaiting", "Confirmed", "On The Way", "Arrived"]))
    tabs = f'<div class="row" style="height:55px;overflow:hidden">{chips}</div>'
    order = "".join(
        f'<div class="grow" style="margin:6px;height:41px;border-radius:50px;display:flex;align-items:center;justify-content:center;'
        f'background:{ACC if i == 0 else "#fff"}"><span class="t14 w500" style="color:{"#fff" if i == 0 else TXT}">{t}</span></div>'
        for i, t in enumerate(["Default Bookings", "Custom Bookings"]))
    return f"""
<div style="position:absolute;left:0;right:0;top:0;z-index:7">{status_bar(BG)}</div>
{big_header('Bookings', '18 Bookings', tabs)}
<div class="col" style="position:absolute;left:16px;right:16px;top:{P['sb']+150+16}px;gap:10px">
  {booking_card(B_NEW)}{booking_card(B_2041)}{booking_card(B_2056)}
</div>
<div class="row" style="position:absolute;left:15px;right:15px;bottom:{P['gb']+70+12}px;height:55px;border-radius:50px;background:#fff;
  border:1px solid {HAIR};z-index:20;box-shadow:0 6px 20px rgba(0,22,46,.08)">{order}</div>
{nav_bar(1)}"""


# ------------------------------------------------------------------ 03 booking details
def screen_booking_details():
    teal = STATUS["confirmed"]
    title = '<span class="t16 w500">Booking Information</span>'
    customer = f"""<div style="background:#fff">
  <div class="t14" style="color:{GREY};padding:10px 15px">Customer</div><div style="height:5px"></div>
  <div style="padding:0 15px">
    <div class="row center">{avatar('AM', 50)}<span style="width:15px"></span>
      <div class="col grow" style="gap:4px"><span class="t16">Ahmed Al Mansoori</span><span class="t12" style="color:{GREY}">+971 50 123 4567</span></div>
      <span style="width:15px"></span><div class="sq" style="width:40px;height:40px;background:{ACC10}">{ic('call', 20, ACC)}</div>
      <span style="width:10px"></span><div class="sq" style="width:40px;height:40px;background:{ACC10}">{ic('dr_chat', 20, ACC)}</div></div>
    <div style="height:16px"></div>
    <div class="row center">{ic('letter', 24, ACC)}<span style="width:5px"></span><span class="t14 grow">ahmed.m@example.com</span>{ic('arrow_next', 16, ACC)}</div>
  </div><div style="height:10px"></div></div>"""
    status = f"""<div class="row center" style="background:#fff;padding:15px;border-top:.5px solid {teal};border-bottom:.5px solid {teal}">
  <div class="row grow"><span class="t14">Status:</span><span style="width:5px"></span><span class="t14" style="color:{teal}">Confirmed</span></div>
  <div class="row"><span class="t14">Invoice No:</span><span style="width:5px"></span><span class="t14" style="color:{teal}">#2056</span></div></div>"""
    when = f"""<div style="background:#fff;padding:15px">
  <div class="row"><span class="t14 grow" style="color:{GREY}">Booking at</span><span class="t14 w700" style="color:{ACC}">Doorstep</span></div>
  <div style="height:5px"></div>
  <div class="row top">{ic('map_pic', 16, ACC)}<span style="width:5px"></span><span class="t14">Villa 12, Al Markaziyah, Abu Dhabi</span></div>
  <div style="height:8px"></div>
  <div class="row top">{ic('call', 16, ACC)}<span style="width:5px"></span><span class="t14">+971 50 123 4567</span></div>
  <div style="height:10px"></div>
  <div class="row center">{ic('b_calender', 16, ACC)}<span style="width:5px"></span><span class="t14 w600">02/11/2026</span>
    <span style="width:8px"></span><span style="width:1px;height:18px;background:{HAIR}"></span><span style="width:8px"></span>
    {ic('b_clock', 16, ACC)}<span style="width:5px"></span><span class="t14 w600">11:00 AM</span></div></div>"""

    def svc(img, t, q, p):
        return (f'<div class="row center" style="padding-bottom:8px"><img src="img/{img}" style="width:40px;height:40px;border-radius:5px;object-fit:cover">'
                f'<span style="width:10px"></span><span class="t14 grow ell">{t}</span><span class="t14" style="color:{GREY};margin:0 12px">Qty. {q}</span>'
                f'<span class="t14 w500">{p}</span></div>')
    services = f"""<div style="background:#fff"><div style="padding:5px 15px">
  <div class="t14 w700">Service Details</div><div style="height:8px"></div>
  {svc('s_15.jpg', 'golden wash salon', 1, 'AED120')}<div style="height:5px"></div></div>
  <div style="height:.5px;background:{GREY}"></div></div>"""
    def bill(t, v):
        return f'<div class="row"><span class="t14 grow">{t}</span><span class="t14 w500">{v}</span></div>'
    price = f"""<div style="background:#fff;padding:15px">
  <div class="row center"><span class="t14 grow" style="color:{GREY}">Bill Details</span>{mat('arrow_drop_down', 24, ACC).replace('<svg ', '<svg style="transform:rotate(180deg)" ')}</div>
  <div class="col" style="gap:10px;padding:8px 0 4px">{bill('Total Service Charges', 'AED120')}{bill('Visiting Charge', 'AED10')}{bill('Tax', 'AED6.50')}</div>
  <div style="height:10px"></div>
  <div class="row center" style="padding:5px 0"><span class="t20 w700 grow">Total Amount</span><span class="t20 w700" style="color:{ACC}">AED136.50</span></div>
  <div style="height:10px"></div><div style="height:.5px;background:{GREY}"></div><div style="height:10px"></div>
  <div class="row center"><span class="t12 grow">Payment Mode</span><span class="t14" style="color:{ACC}">Pay On Service</span></div></div>"""
    bar = "".join(f'<div class="btn" style="height:50px">{t}</div>' for t in ["On The Way", "Reschedule", "Cancel"])
    return f"""
<div class="appbar" style="box-shadow:0 4px 14px rgba(0,22,46,.12)">{status_bar(CARD)}
  <div class="row center" style="height:56px;position:relative">{back_arrow()}<div style="{'position:absolute;left:0;right:0;text-align:center' if P['ios'] else ''}">{title}</div></div></div>
<div class="col" style="position:absolute;left:0;right:0;top:{P['sb']+56+10}px">
  {customer}<div style="height:10px"></div>{status}<div style="height:10px"></div>{when}{services}{price}
</div>
<div class="row" style="position:absolute;left:0;right:0;bottom:0;background:#fff;padding:10px 15px {10+P['gb']}px;gap:10px;z-index:20;
  box-shadow:0 -4px 20px rgba(0,22,46,.06)">{bar}</div>
{gesture()}"""


# ------------------------------------------------------------------ 04 services
def service_row(img, title, rating, reviews, minutes, price, old=None, active=True):
    st = (f'{ic("active_state", 18, GREEN)}<span style="width:5px"></span><span class="t14">Active</span>' if active else
          f'{ic("deactive", 18, GREY)}<span style="width:5px"></span><span class="t14" style="color:{GREY}">Deactive</span>')
    strike = (f'<span class="t12" style="color:{ACC};text-decoration:line-through">{old}</span>' if old else "")
    return f"""<div class="card row top" style="padding:15px;border:1px solid {BG}">
  <div class="col grow">
    <div class="row center">{st}</div><div style="height:5px"></div>
    <span class="t16 w600">{title}</span><div style="height:5px"></div>
    <div class="row center">{ic('star', 16, STAR)}<span style="width:5px"></span><span class="t14 w600">{rating}</span>
      <span style="width:8px"></span><span style="width:1px;height:16px;background:{HAIR}"></span><span style="width:8px"></span>
      <span class="t14 w600">{reviews} Reviews</span></div><div style="height:5px"></div>
    <div class="row center" style="gap:5px">{ic('group', 16, ACC)}<span class="t12 w600">1 Persons</span>
      <span style="width:2px"></span>{ic('duration', 16, ACC)}<span class="t12 w600">{minutes} Minutes</span></div><div style="height:5px"></div>
    <div class="row" style="gap:5px;align-items:baseline"><span class="t18 w600">{price}</span>{strike}</div>
  </div>
  <img src="img/{img}" style="width:100px;height:120px;border-radius:10px;object-fit:cover;flex:none">
</div>"""


def screen_services():
    search = f"""<div class="row center" style="padding:10px 0 0 20px">
  <div class="sq" style="width:40px;height:40px;border-radius:6px;padding:6px;background:{ACC12}">{ic('filter', 28, ACC)}</div>
  <span style="width:10px"></span>
  <div class="row center" style="margin:0 12px;width:{412/1.32:.0f}px;height:40px;border-radius:6px;border:1px solid {GREY};background:#fff;padding:0 12px;gap:10px">
    {ic('search', 22, 'rgba(0,22,46,.7)')}<span style="font-size:15px;color:{GREY}">Search Services</span></div></div>"""
    rows = "".join([
        service_row('s_12.jpg', 'deep wash salon', '4.9', 38, 90, 'AED249', 'AED299'),
        service_row('s_15.jpg', 'golden wash salon', '4.8', 26, 60, 'AED120'),
        service_row('s_17.jpg', 'silver wash salon', '4.7', 19, 40, 'AED80'),
        service_row('s_19.jpg', 'normal wash salon', '4.6', 31, 30, 'AED75'),
    ])
    add = (f'<div style="position:absolute;left:15px;right:15px;bottom:{P['gb']+50}px;height:56px;border-radius:10px;background:{ACC};z-index:22;'
           f'display:flex;align-items:flex-start;justify-content:center;padding-top:11px;gap:10px;box-shadow:0 -4px 18px rgba(84,101,255,.25)">'
           f'{ic("add_circle", 20, "#fff")}<span class="t14" style="color:#fff">Add New Service</span></div>')
    return f"""
<div style="position:absolute;left:0;right:0;top:0;z-index:7">{status_bar(BG)}</div>
{big_header('Services', '25 Services', search)}
<div class="col" style="position:absolute;left:15px;right:15px;top:{P['sb']+150+15}px;gap:10px">{rows}</div>
{add}
<div style="position:absolute;left:0;right:0;bottom:0;height:{P['gb']+40}px;z-index:24"></div>
{nav_bar(2)}"""


# ------------------------------------------------------------------ 05 job requests
def job_card(title, desc, lo, hi, user, initials, ago, bg):
    return f"""<div class="card" style="padding:10px">
  <div class="t14 w600">{title}</div><div style="height:5px"></div>
  <div class="t13" style="color:{GREY};display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden">{desc}</div>
  <div style="height:10px"></div><div class="t13" style="color:{GREY}">Budget</div>
  <div class="row" style="align-items:baseline"><span class="t16 w600">{lo}</span><span class="t13" style="color:{GREY}">&nbsp;To&nbsp;</span><span class="t16 w600">{hi}</span></div>
  {divider()}
  <div class="row center">{avatar(initials, 35, bg[0], bg[1])}<span style="width:8px"></span>
    <div class="col" style="flex:1 1 0;min-width:0"><span class="t12 w600 ell">{user}</span><span class="t12" style="color:{GREY}">{ago}</span></div>
    <span style="width:15px"></span>
    <div class="row center" style="flex:1 1 0;height:35px;border-radius:5px;background:{ACC10};justify-content:center;gap:8px">
      <span class="t13" style="color:{ACC}">Apply Now</span>{ic('arrow_next', 16, ACC)}</div></div>
</div>"""


def screen_jobs():
    switch = (f'<div style="width:51px;height:31px;border-radius:16px;background:rgba(84,101,255,.5);position:relative;flex:none">'
              f'<span style="position:absolute;right:2px;top:2px;width:27px;height:27px;border-radius:50%;background:{TXT};'
              f'box-shadow:0 3px 8px rgba(0,0,0,.15),0 3px 1px rgba(0,0,0,.06)"></span></div>') if P['ios'] else              (f'<div style="width:52px;height:32px;border-radius:16px;background:{ACC};position:relative;flex:none">'
              f'<span style="position:absolute;right:4px;top:4px;width:24px;height:24px;border-radius:50%;background:#fff"></span></div>')
    actions = (f'<div class="sq" style="width:40px;height:36px;background:{ACC10}">{mat("format_list_bulleted", 24, ACC)}</div>'
               f'<span style="width:5px"></span>{switch}<span style="width:15px"></span>')
    tabs = "".join(
        f'<div class="grow" style="margin:10px;height:35px;border-radius:5px;display:flex;align-items:center;justify-content:center;'
        f'background:{ACC if i == 0 else "#fff"};border:1px solid {ACC if i == 0 else "rgba(0,22,46,.5)"}">'
        f'<span class="t14 w500" style="color:{"#fff" if i == 0 else TXT}">{t}</span></div>'
        for i, t in enumerate(["Open Jobs", "Applied jobs"]))
    bottom = f'<div class="row" style="height:55px;padding:0 5px">{tabs}</div>'
    cards = "".join([
        job_card("Ceramic coating for SUV", "Ceramic coating and full interior detailing for a 2022 Toyota Land Cruiser. The car is parked at home in Al Markaziyah.",
                 "AED400", "AED900", "Ahmed Al Mansoori", "AM", "Just now", ("#E6E9FF", ACC)),
        job_card("Weekly wash for 3 family cars", "Exterior and interior wash every Saturday morning for two sedans and one SUV in Khalifa City.",
                 "AED350", "AED600", "Omar Khalid", "OK", "2 hours ago", ("#E3F5F6", "#009EA8")),
        job_card("Engine bay & headlight restoration", "Engine bay steam cleaning and headlight polishing for a 2018 Nissan Patrol before resale.",
                 "AED250", "AED450", "Fatima Hassan", "FH", "5 hours ago", ("#FFF1E0", "#E68A00")),
        job_card("Pre-sale detailing for sedan", "Full exterior polish and interior shampoo for a 2020 Lexus ES in Al Reem Island.",
                 "AED300", "AED550", "Sara Al Nuaimi", "SN", "1 day ago", ("#E8F5E9", "#1E9400")),
    ])
    return f"""
{simple_app_bar('Job Request’s', actions, bottom=bottom)}
<div class="col" style="position:absolute;left:15px;right:15px;top:{P['sb']+56+55+10}px;gap:10px">{cards}</div>
{safe_inset()}{gesture()}"""


# ------------------------------------------------------------------ 06 chat
def bubble(text, time, me):
    r = "12px 0 12px 12px" if me else "12px 12px 12px 0"
    bg, fg = (ACC, "#fff") if me else ("#fff", TXT)
    al = "flex-end" if me else "flex-start"
    return f"""<div class="col" style="align-items:{al};margin:6px 0">
  <span class="t10" style="color:{GREY};margin-bottom:2px">{time}</span>
  <div style="max-width:{(412-30)*0.8:.0f}px;background:{bg};color:{fg};border-radius:{r};padding:10px;font-size:14px;line-height:1.4">{text}</div></div>"""


def screen_chat():
    head = (f'<div class="row center">{avatar("AM", 48)}<span style="width:15px"></span>'
            f'<div class="col"><span class="t18">Ahmed Al Mansoori</span><span class="t14" style="color:{GREY}">Booking Id- 2041</span></div></div>')
    msgs = "".join([
        bubble("Hi! I booked the deep wash salon for tomorrow at 10:00 AM. The car is at Villa 12, Al Markaziyah.", "09:12 AM", False),
        bubble("Hello, thank you for booking with bareeq plus. Our team will be there at 10:00 AM.", "09:14 AM", True),
        bubble("Could you please park the car in a shaded spot? We bring our own water and steam equipment.", "09:14 AM", True),
        bubble("Sure, it will be in the driveway. Is seat protection included?", "09:16 AM", False),
        bubble("Yes. Deep interior cleaning, exterior wash, car perfume and seat wrapping are all included.", "09:17 AM", True),
        bubble("Perfect, see you tomorrow!", "09:18 AM", False),
        '<div class="row" style="justify-content:center;padding:8px 0"><span class="t12">Today</span></div>',
        bubble("Good morning! Our team is on the way and will arrive in about 20 minutes.", "09:38 AM", True),
        bubble("Great, the gate is open.", "09:40 AM", False),
    ])
    tb = 892 * 0.08
    return f"""
<div class="appbar" style="border-bottom:1px solid {HAIR}">{status_bar(CARD)}
  <div class="row center" style="height:{tb:.0f}px">{back_arrow()}<div class="grow">{head}</div>
    <div style="padding:12px">{mat('more_vert', 24, TXT)}</div></div></div>
<div style="position:absolute;left:0;right:0;top:{P['sb']+tb+1:.0f}px;padding:8px 15px 0">
  <div class="row" style="justify-content:center;padding:8px 0"><span class="t12">Yesterday</span></div>
  {msgs}
</div>
<div class="row center" style="position:absolute;left:0;right:0;bottom:0;background:#fff;padding:10px 15px {10+P['gb']}px;z-index:20">
  <div style="padding:8px;display:flex">{ic('add_attachment', 20, ACC)}</div><span style="width:10px"></span>
  <div class="grow" style="background:{BG};border-radius:8px;padding:14px 10px"><span class="t14" style="color:{ACC}">Type Message here</span></div>
  <span style="width:10px"></span>
  <div class="sq" style="width:48px;height:48px;border-radius:8px;background:rgba(84,101,255,.12)">{ic('send_message', 24, ACC)}</div>
</div>
{gesture()}"""


# ------------------------------------------------------------------ 07 working hours
def screen_hours():
    def tbtn(t):
        return f'<span class="t11 w500" style="padding:5px 6px;border-radius:6px;background:{ACC10};color:{ACC}">{t}</span>'

    def slot(a, b, last):
        act = (f'<div class="sq" style="padding:4px;border-radius:4px;background:{ACC10}">{mat("add", 16, ACC)}</div>' if last else
               f'<div class="sq" style="padding:4px;border-radius:4px;background:rgba(244,67,54,.1)">{mat("delete_outline", 16, RED)}</div>')
        return (f'<div class="row center">{tbtn(a)}<span class="t10" style="color:{GREY};padding:4px">—</span>{tbtn(b)}'
                f'<span style="width:4px"></span>{act}</div>')

    def day(name, slots):
        on = bool(slots)
        right = (f'<div class="col" style="align-items:flex-end;gap:6px">' +
                 "".join(slot(a, b, i == len(slots) - 1) for i, (a, b) in enumerate(slots)) + '</div>') if on else \
            f'<span class="t13" style="color:{GREY};font-style:italic">Closed</span>'
        return f"""<div class="row center" style="margin-bottom:10px;padding:10px;border-radius:8px;
  border:.8px solid {ACC if on else GREY};background:{'rgba(84,101,255,.04)' if on else BG}">
  {ic('check_circle', 20, ACC if on else GREY)}<span style="width:8px"></span>
  <span class="t14 w500 grow" style="color:{TXT if on else GREY}">{name}</span>{right}</div>"""
    split = [("08:00 AM", "01:00 PM"), ("04:00 PM", "10:00 PM")]
    days = "".join([
        day("Sunday", split), day("Monday", split), day("Tuesday", split), day("Wednesday", split),
        day("Thursday", split), day("Friday", []), day("Saturday", [("09:00 AM", "06:00 PM")]),
    ])
    act = f'<span class="t13" style="color:{ACC};padding-right:16px">Apply to all</span>'
    return f"""
{simple_app_bar('Working Hours', act)}
<div style="position:absolute;left:16px;right:16px;top:{P['sb']+56+16}px" class="card"><div style="padding:16px">
  <div class="t16 w600">Working Schedule</div><div style="height:4px"></div>
  <div class="t13" style="color:{GREY}">Configure when your services are available to customers.</div><div style="height:8px"></div>
  <div class="row center">{ic('b_clock', 14, ACC)}<span style="width:6px"></span><span class="t12 w500" style="color:{ACC}">Slot Interval: 30 mins</span></div>
  <div style="height:12px"></div>{days}</div></div>
<div style="position:absolute;left:0;right:0;bottom:0;padding:8px 16px {16+P['gb']}px;background:{BG};z-index:20" class="row">{btn('Save', 48, 'font-size:16px;font-weight:500')}</div>
{gesture()}"""


# ------------------------------------------------------------------ 08 withdrawals
def screen_withdrawals():
    tabs = "".join(
        f'<span class="t14" style="padding:6px 18px;border-radius:6px;{"background:" + ACC + ";color:#fff" if i == 0 else ""}">{t}</span>'
        for i, t in enumerate(["All", "Pending", "Approved", "Rejected", "Settled"]))

    def req(amount, date, status, label):
        return f"""<div class="card" style="padding:12px;box-shadow:0 1px 2px rgba(0,22,46,.08)">
  <div class="row"><span class="t16 w500 grow">{amount}</span><span class="t12" style="color:{GREY}">{date}</span></div>
  <div style="height:5px"></div>
  <div class="row"><span class="t12 grow" style="color:{GREY}">AC/ 0412 7781 4821</span><span class="t14" style="color:{STATUS[status]}">{label}</span></div></div>"""
    rows = "".join([
        req("AED2,000", "30/10/2026", "pending", "Pending"),
        req("AED1,500", "22/10/2026", "approved", "Approved"),
        req("AED3,200", "12/10/2026", "settled", "Settled"),
        req("AED2,400", "01/10/2026", "settled", "Settled"),
        req("AED1,850", "18/09/2026", "settled", "Settled"),
        req("AED2,750", "04/09/2026", "settled", "Settled"),
        req("AED1,200", "21/08/2026", "settled", "Settled"),
    ])
    help_ = f'<div style="padding:12px 22px 12px 12px">{mat("help_outline", 24, TXT)}</div>'
    return f"""
{simple_app_bar('Withdrawal Requests', help_, shadow=True)}
<div class="col center" style="position:absolute;left:5px;right:5px;top:{P['sb']+56+5}px;height:125px;padding:5px">
  <span class="t13">Your Balance</span><div style="height:5px"></div><span class="t18 w600">AED4,860</span>
  <div style="height:15px"></div><div class="row center" style="align-self:flex-start;gap:4px;padding-left:4px">{tabs}</div></div>
<div style="position:absolute;left:10px;right:10px;top:{P['sb']+56+135}px" class="hr"></div>
<div class="col" style="position:absolute;left:15px;right:15px;top:{P['sb']+56+146}px;gap:10px">{rows}</div>
<div style="position:absolute;left:0;right:0;bottom:0;padding:10px 15px {10+P['gb']}px;background:linear-gradient(rgba(245,246,247,0),{BG} 30%);z-index:20">
  <div class="row center" style="height:48px;border-radius:10px;background:{ACC};justify-content:center;gap:10px">
    {ic('add', 20, '#fff')}<span class="t16" style="color:#fff">Add New Request</span></div></div>
{gesture()}"""


if __name__ == "__main__":
    import sys
    set_platform("ios" in sys.argv[1:])
    pre = "ios_" if P["ios"] else ""
    _save = save
    save = lambda name, html: _save(pre + name, html)
    floating = (f'<div class="float" style="left:640px;top:1745px;width:300px;transform:scale(1.3) rotate(-2.5deg)">{booking_card(B_2049)}</div>' if P["ios"] else
                f'<div class="float" style="left:628px;top:1408px;width:300px;transform:scale(1.22) rotate(-2.5deg)">{booking_card(B_2049)}</div>')
    save("01_home", page('Grow your business,<br><em>all in one app</em>', 'Bookings, earnings &amp; your plan at a glance', screen_home(), extra_html=floating))
    save("02_bookings", page('Accept bookings<br><em>in one tap</em>', 'Confirm or decline new jobs instantly', screen_bookings(), deco=1))
    save("03_booking", page('Run every job<br><em>start to finish</em>', 'Customer details, status updates &amp; billing', screen_booking_details()))
    save("04_services", page('Your services,<br><em>your prices</em>', 'Add, edit &amp; track every service you offer', screen_services(), deco=1))
    save("05_jobs", page('Win new work<br><em>from job requests</em>', 'Bid on custom requests from nearby customers', screen_jobs()))
    save("06_chat", page('Chat directly<br><em>with customers</em>', 'Confirm the details before you arrive', screen_chat(), deco=1))
    save("07_hours", page('Work on<br><em>your own schedule</em>', 'Set working days, hours &amp; time slots', screen_hours()))
    save("08_withdraw", page('Get paid,<br><em>withdraw anytime</em>', 'Track your balance and payout requests', screen_withdrawals(), deco=1))
    print("ok")
