// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../config.dart';
import 'layouts/monthly_yearly_layout.dart';
import 'layouts/plan_card_layout.dart';

class PlanDetailsScreen extends StatelessWidget {
  const PlanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, PlanDetailsProvider>(
      builder: (context, lang, value, child) {
        // Filter plans from value.planList
        final filteredPlans = value.products.where((product) {
          return value.isMonthly
              ? product.id.contains('month')
              : product.id.contains('year');
        }).toList();

        log("Filtered Plans (${value.isMonthly ? 'Monthly' : 'Yearly'}):");
        for (var product in filteredPlans) {
          log("Product ID: ${product.id}");

          log("Price: ${product.price}");
          log("Currency: ${product.currencyCode}");
          log("-------------------");
        }

        return WillPopScope(
          onWillPop: () {
            return route.pushReplacementNamed(context,
                userModel == null ? routeName.intro : routeName.dashboard);
          },
          child: StatefulWrapper(
            onInit: () => Future.delayed(
                const Duration(milliseconds: 50), () => value.onReady(context)),
            child: Scaffold(
              appBar: AppBarCommon(
                title: translations!.planDetails,
                onTap: () => route.pushReplacementNamed(context,
                    userModel == null ? routeName.intro : routeName.dashboard),
              ),
              body: value.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MonthlyYearlyLayout(
                                isMonthly: value.isMonthly,
                                onToggle: (val) => value.onToggle(val),
                              ),
                              const VSpace(Sizes.s30),
                              filteredPlans.isNotEmpty
                                  ? CarouselSlider(
                                      carouselController:
                                          value.carouselController,
                                      options: CarouselOptions(
                                        enableInfiniteScroll: false,
                                        autoPlayCurve:
                                            Easing.emphasizedAccelerate,
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 500),
                                        enlargeCenterPage: true,
                                        height: 620,
                                        viewportFraction: 0.70,
                                        onPageChanged: (index, reason) =>
                                            value.onPageChange(index, reason),
                                        scrollDirection: Axis.horizontal,
                                      ),
                                      items: filteredPlans
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final ProductDetails plan = entry.value;
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return SingleChildScrollView(
                                              child: PlanCardLayout(
                                                onTapSelectPlan: () {
                                                  value.selectPlanByProduct(
                                                      plan, context);
                                                },
                                                isYear: !value.isMonthly,
                                                data:
                                                    plan, // ✅ SubscriptionModel
                                                selectIndex: value.selIndex,
                                                index: entry.key,
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    )
                                  : const CommonEmpty(),
                            ],
                          ),
                          if (filteredPlans.isNotEmpty)
                            Text(
                              language(context, translations!.noteYouCanUpdate),
                              textAlign: TextAlign.center,
                              style: appCss.dmDenseRegular14.textColor(
                                  appColor(context).appTheme.darkText),
                            )
                                .paddingSymmetric(
                                    horizontal: Insets.i28,
                                    vertical: Insets.i20)
                                .decorated(
                                    color:
                                        appColor(context).appTheme.fieldCardBg),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
