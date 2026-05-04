import '../../../config.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context1, languageCtrl, child) {
      return Scaffold(
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              leadingWidth: 80,
              leading: CommonArrow(
                  arrow: languageCtrl.getLocal() == "ar"
                      ? eSvgAssets.arrowRight
                      : eSvgAssets.arrowLeft,
                  onTap: () => route.pop(context)).paddingAll(Insets.i8),
              title: Text(
                  language(
                      context, language(context, translations!.changeLanguage)),
                  style: appCss.dmDenseBold18
                      .textColor(appColor(context).appTheme.darkText))),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RadioLayout(),
                ButtonCommon(
                    isLoading: languageCtrl.isTranslateLoader ? true : false,
                    title: translations!.update,
                    onTap: () {
                      // showLoading(context);
                      languageCtrl.changeLocale(
                          languageCtrl.languageList[languageCtrl.selectedIndex!],
                          context);

                      Future.delayed(const Duration(seconds: 1)).then(
                        (value) {
                          hideLoading(context);
                        },
                      );
                      final userApi = Provider.of<UserDataApiProvider>(context,
                          listen: false);
                      final commonApi = Provider.of<CommonApiProvider>(context,
                          listen: false);
                      // userApi.homeStatisticApi();
                      userApi.getCategory();
                      commonApi.getDashBoardApi(context);
                      userApi.getPopularServiceList();
                      userApi.getAllServiceList();
                      userApi.getJobRequest(context);
                      userApi.getBookingHistory(context);
                      if (!isFreelancer) {
                        userApi.getServicemenByProviderId();
                      }
                      // userApi.getBankDetails();
                      // userApi.getDocumentDetails();
                      userApi.getAddressList(context);
                      userApi.getNotificationList();
                      if (isFreelancer || !isServiceman) {
                        userApi.getServicePackageList();
                      }
                      commonApi.getKnownLanguage();
                      // commonApi.getSubscriptionPlanList(context);
                      commonApi.getDocument();
                      commonApi.getCountryState();
                      commonApi.getZoneList();
                      commonApi.getCurrency();
                      commonApi.getBlog();
                      // commonApi.getAllCategory();
                      // commonApi.getTax();
                      commonApi.getBookingStatus();
                      commonApi.getPaymentMethodList();
                    }).paddingAll(Insets.i20)
              ]));
    });
  }
}
