import 'dart:developer';

import '../../../../config.dart';

class SignupLinearProgressbar extends StatelessWidget {
  final int? pageIndex;
  const SignupLinearProgressbar({super.key, this.pageIndex});

  @override
  Widget build(BuildContext context) {
    log("isFreelancer:$isFreelancer");
    return Stack(
      alignment: rtl(context) ? Alignment.centerLeft : Alignment.centerRight,
      children: [
        LinearPercentIndicator(
            animation: true,
            padding: const EdgeInsets.symmetric(horizontal: Insets.i20),
            width: MediaQuery.of(context).size.width,
            lineHeight: Sizes.s46,
            barRadius: const Radius.circular(AppRadius.r8),
            percent: isFreelancer
                ? pageIndex == 2
                    ? 0.50
                    : 1
                : pageIndex == 0
                    ? 0.35
                    : pageIndex == 1
                        ? 0.70
                        : 1,
            backgroundColor:
                appColor(context).appTheme.primary.withOpacity(0.6),
            progressColor: appColor(context).appTheme.primary,
            center: Text(
                    language(
                        context,
                        pageIndex == 2
                            ? translations!.fewMoreSteps1
                            : translations!.fewMoreSteps),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.whiteBg))
                .paddingSymmetric(horizontal: Insets.i13)),
      ],
    );
  }
}
