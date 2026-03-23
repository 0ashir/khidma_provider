import 'package:collection/collection.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import '../../../../config.dart';

class PlanCardLayout extends StatelessWidget {
  final dynamic data; // Changed to SubscriptionModel
  final int? selectIndex, index;
  final bool? isYear;
  final GestureTapCallback? onTapSelectPlan;

  const PlanCardLayout({
    super.key,
    required this.data, // Made required
    this.selectIndex,
    this.index,
    this.isYear = false,
    this.onTapSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlanDetailsProvider>(context);
    final currentPlan = provider.planList.firstWhereOrNull(
      (plan) => plan.productId == data.id,
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(selectIndex == index
              ? eImageAssets.planBg
              : eImageAssets.planBgUnselect),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Column(children: [
            Text(data.price.toString(),
                style: selectIndex == index
                    ? appCss.dmDenseSemiBold16
                        .textColor(appColor(context).appTheme.darkText)
                    : appCss.dmDenseSemiBold16
                        .textColor(appColor(context).appTheme.whiteColor)),
            Text("/${isYear == false ? "month" : "year"}",
                style: selectIndex == index
                    ? appCss.dmDenseMedium12
                        .textColor(appColor(context).appTheme.lightText)
                    : appCss.dmDenseMedium10
                        .textColor(appColor(context).appTheme.whiteColor))
          ])
              .paddingSymmetric(vertical: Insets.i13, horizontal: Insets.i15)
              .decorated(
                  color: selectIndex == index
                      ? appColor(context).appTheme.whiteBg
                      : appColor(context).appTheme.primary,
                  shape: BoxShape.circle)
              .paddingAll(Insets.i4)
              .decorated(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: appColor(context)
                        .appTheme
                        .darkText
                        .withValues(alpha: 0.5),
                    blurRadius: 2,
                  ),
                ],
                gradient: LinearGradient(
                  colors: selectIndex == index
                      ? [
                          appColor(context).appTheme.whiteBg,
                          appColor(context).appTheme.stroke,
                        ]
                      : [
                          appColor(context).appTheme.primary.withOpacity(0.3),
                          appColor(context).appTheme.primary,
                        ],
                ),
              )
              .paddingOnly(top: Insets.i8),
          const VSpace(Sizes.s12),
          Column(
            children: [
              Text(
                "${currentPlan?.name}",
                style: selectIndex == index
                    ? appCss.dmDenseSemiBold20
                        .textColor(appColor(context).appTheme.whiteBg)
                    : appCss.dmDenseSemiBold15
                        .textColor(appColor(context).appTheme.primary),
              ),
              const VSpace(Sizes.s20),
              ...?currentPlan?.benefits?.asMap().entries.map(
                    (e) => PlanRowCommon(
                      title: e.value,
                      index: index,
                      selectIndex: selectIndex,
                    ),
                  ), // Use SubscriptionModel benefits
              Image.asset(eImageAssets.bulletDotted, width: Sizes.s215)
                  .paddingOnly(top: Insets.i5, bottom: Insets.i15),
              Text(
                language(context, translations!.takeYourService),
                textAlign: TextAlign.center,
                style: selectIndex == index
                    ? appCss.dmDenseRegular12
                        .textColor(appColor(context).appTheme.whiteBg)
                    : appCss.dmDenseRegular10
                        .textColor(appColor(context).appTheme.lightText),
              ).width(Sizes.s200),
              const VSpace(Sizes.s25),
              ButtonCommon(
                onTap: (activeSubscription?.productId != null)
                    ? () {
                        showErrorToast(
                            context, "You have already purchased plan.");
                      }
                    : onTapSelectPlan,
                title: (activeSubscription?.productId == data.id.toString() &&
                        activeSubscription != null)
                    ? "subscribe"
                    : translations!.selectPlan,
                width: selectIndex == index ? Sizes.s145 : Sizes.s112,
                style: selectIndex == index
                    ? appCss.dmDenseSemiBold16
                        .textColor(appColor(context).appTheme.darkText)
                    : appCss.dmDenseRegular12
                        .textColor(appColor(context).appTheme.whiteColor),
                color: selectIndex == index
                    ? appColor(context).appTheme.whiteBg
                    : appColor(context).appTheme.primary,
              ),
            ],
          ).padding(
            horizontal: Insets.i25,
            bottom: selectIndex == index ? Insets.i25 : Insets.i15,
          ),
        ],
      ),
    );
  }
}
