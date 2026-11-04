Khidma Provider - Google Play phone screenshots

8 screenshots, 1080x1920 PNG (9:16), opaque RGB, in store order:
01_home       Dashboard: subscription, booking counts, earnings chart
02_bookings   Booking list with accept / decline
03_booking    Booking information and status actions
04_services   Service management
05_jobs       Custom job requests
06_chat       Customer chat
07_hours      Working hours / time slots
08_withdraw   Withdrawal requests and balance

These are marketing compositions built from HTML/CSS that mirrors the Flutter
widgets in lib/ui/screens (colours from lib/utils/colors.dart, Outfit font);
they are not captures from a running device.

Source: source/  (kit.py = shared tokens and frame, screens.py = the 8 screens)
Rebuild: python source/render.py            (all)
         python source/render.py 02_bookings (one)
Requires Python with playwright + Pillow.
