import '../../../../config.dart';

class SubscriptionPlanLayout extends StatelessWidget {
  final SubscriptionPlanModel? data;
  final Animation<Offset> position;

  const SubscriptionPlanLayout({super.key, this.data, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Sizes.s525,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(eImageAssets.subPlanBg), fit: BoxFit.fill)),
        child: SingleChildScrollView(
            child: data != null
                ? Column(children: [
                    Text(
                        "Try ${appSettingModel?.subscriptionPlan?.freeTrialDays} Days For Free"
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: appCss.dmDenseSemiBold20
                            .textColor(appColor(context).appTheme.whiteColor)),
                    const VSpace(Sizes.s8),
                    Text(language(context, data!.subtext),
                        textAlign: TextAlign.center,
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.whiteColor)),
                    const VSpace(Sizes.s20),
                    ...data!.benefits!.map((e) => PlanRowCommon(
                        title: e, index: null, selectIndex: null)),
                    UnlockPlan(position: position),
                    const VSpace(Sizes.s15),
                    ButtonCommon(
                            onTap: () => route.pushNamed(
                                  context,
                                  routeName.planDetails,
                                  arg: {"isTrial": true},
                                ),
                            title:
                                "Start Your ${appSettingModel?.subscriptionPlan?.freeTrialDays}-Days Free Trial",
                            color: appColor(context).appTheme.red)
                        .paddingOnly(bottom: Insets.i10)
                  ]).padding(top: Insets.i60, horizontal: Insets.i25)
                : Container()));
  }
}
