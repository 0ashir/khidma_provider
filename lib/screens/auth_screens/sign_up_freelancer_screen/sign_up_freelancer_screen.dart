// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:fixit_provider/screens/auth_screens/sign_up_freelancer_screen/layouts/sign_up_one_freelancer.dart';

import '../../../config.dart';

class SignupFreelancerScreen extends StatefulWidget {
  const SignupFreelancerScreen({super.key});

  @override
  State<SignupFreelancerScreen> createState() => _SignupFreelancerScreenState();
}

class _SignupFreelancerScreenState extends State<SignupFreelancerScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context1) {
    return Consumer<SignUpCompanyProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(
            const Duration(milliseconds: 50), () => value.onReady(context)),
        child: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) => value.popInvokeFree(didPop, context),
          child: LoadingComponent(
            child: Scaffold(
                appBar: AppBarCommon(title: translations!.signUp),
                body: SingleChildScrollView(
                    controller: value.controller,
                    child: Column(children: [
                      // Stack(
                      //   alignment: rtl(context)
                      //       ? Alignment.centerLeft
                      //       : Alignment.centerRight,
                      //   children: [
                      //     LinearPercentIndicator(
                      //         animation: true,
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: Insets.i20),
                      //         width: MediaQuery.of(context).size.width,
                      //         lineHeight: Sizes.s46,
                      //         barRadius: const Radius.circular(AppRadius.r8),
                      //         percent: value.fPageIndex == 0 ? 0.50 : 1,
                      //         backgroundColor: appColor(context)
                      //             .appTheme
                      //             .primary
                      //             .withOpacity(0.6),
                      //         progressColor: appColor(context).appTheme.primary,
                      //         center: Text(
                      //                 language(
                      //                     context,
                      //                     value.fPageIndex == 1
                      //                         ? translations!.fewMoreSteps1
                      //                         : translations!.fewMoreSteps),
                      //                 style: appCss.dmDenseMedium14.textColor(
                      //                     appColor(context).appTheme.whiteBg))
                      //             .paddingSymmetric(horizontal: Insets.i15)),
                      //     Image.asset(eGifAssets.coin,
                      //             height: Sizes.s26, width: Sizes.s26)
                      //         .paddingSymmetric(horizontal: Insets.i35)
                      //   ],
                      // ),
                      const VSpace(Sizes.s15),
                      Stack(children: [
                        const FieldsBackground(),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  language(
                                          context,
                                          value.fPageIndex == 0
                                              ? translations!.freelancerDetails
                                              : translations!.locationDetails)
                                      .toUpperCase(),
                                  style: appCss.dmDenseMedium16.textColor(
                                      appColor(context).appTheme.darkText)),
                              const DottedLines()
                                  .paddingSymmetric(vertical: Insets.i20),
                              /* value.fPageIndex == 0
                                  ? */
                              const SignUpOneFreelancer()
                              // : SignUpTwoFreelancer(sync: this)
                            ]).paddingSymmetric(vertical: Insets.i20)
                      ]).paddingSymmetric(horizontal: Insets.i20),
                      ButtonCommon(
                          title: /* value.fPageIndex == 0
                                  ? translations!.next
                                  : */
                              translations!.finish,
                          onTap: () =>
                              value.onFreelancerTap(context)).paddingSymmetric(
                          horizontal: Insets.i20, vertical: Insets.i20)
                    ]))),
          ),
        ),
      );
    });
  }
}
