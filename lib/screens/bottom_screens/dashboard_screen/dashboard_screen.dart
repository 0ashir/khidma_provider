// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unused_local_variable

import 'package:fixit_provider/firebase/firebase_api.dart';
import 'package:fixit_provider/screens/app_pages_screens/pick_up_call/pick_up_call.dart';
import 'package:fixit_provider/screens/bottom_screens/dashboard_screen/provider_botton_nav.dart';
import 'package:fixit_provider/screens/bottom_screens/dashboard_screen/serviceman_botton_nav.dart';

import '../../../config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    //  implement initState
    WidgetsBinding.instance.addObserver(this);

    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    // userApi.commonCallApi(context);
    // userApi.getCategory();
    final chat = Provider.of<ChatHistoryProvider>(context, listen: false);
    chat.onReady(context);
    Provider.of<CommonApiProvider>(context, listen: false)
        .getSubscriptionPlanList(context);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (!mounted) FirebaseApi().onlineActiveStatusChange(false);

      final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
      final booking = Provider.of<BookingProvider>(context, listen: false);
      if (booking.bookingList.isEmpty) {
        // Load from local storage if empty
        await userApi.loadBookingsFromLocal(context);
      }

      final allUserApi =
      Provider.of<UserDataApiProvider>(context, listen: false);
      // allUserApi.commonCallApi(context);

      // final all = Provider.of<CommonApiProvider>(context, listen: false);
      // all.commonApi(context);
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      FirebaseApi().onlineActiveStatusChange(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DashboardProvider, ThemeService, NoInternetProvider>(
        builder: (contextTheme, value, theme, noInter, child) {
          return PickupLayout(
            scaffold: StatefulWrapper(
                onInit: () =>
                    Future.delayed(const Duration(milliseconds: 150)).then(
                          (valuee) => value.onReady(context),
                    ),
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    value.onBack(context);
                  },
                  child: Scaffold(
                      extendBody: true,
                      resizeToAvoidBottomInset: false,
                      bottomNavigationBar: Container(
                        // height: 76,
                          decoration: ShapeDecoration(
                              shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.only(
                                      topLeft: SmoothRadius(
                                          cornerRadius: 18, cornerSmoothing: 1),
                                      topRight: SmoothRadius(
                                          cornerRadius: 18, cornerSmoothing: 1))),
                              shadows: [
                                BoxShadow(
                                    color: appColor(context)
                                        .appTheme
                                        .darkText
                                        .withValues(alpha: 0.10),
                                    blurRadius: 4,
                                    spreadRadius: 0)
                              ]),
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: BottomAppBar(
                                  elevation: 10,
                                  height: 76,
                                  shape: const CircularNotchedRectangle(),
                                  padding: EdgeInsets.zero,
                                  shadowColor: appColor(context)
                                      .appTheme
                                      .darkText
                                      .withValues(alpha: 0.5),
                                  notchMargin: 6,
                                  child: isServiceman
                                      ? const ServicemanBottomNav()
                                      : const ProviderBottomNav()))),
                      body: Consumer<ThemeService>(builder: (context, theme, child) {
                        return Center(child: value.pages[value.selectIndex]);
                      }),
                      floatingActionButton: isServiceman
                          ? Container()
                          : SizedBox(
                          height: Sizes.s50,
                          width: Sizes.s50,
                          child: SvgPicture.asset(eSvgAssets.add,
                              colorFilter: ColorFilter.mode(
                                  appColor(context).appTheme.whiteColor,
                                  BlendMode.srcIn))
                              .paddingAll(Insets.i10))
                          .decorated(
                          color: appColor(context).appTheme.primary,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(AppRadius.r30)))
                          .inkWell(onTap: () => value.onAdd(context)),
                      floatingActionButtonLocation: isServiceman ? null : FloatingActionButtonLocation.centerDocked),
                )),
          );
        });
  }
}