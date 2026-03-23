import '../../../config.dart';

class SignUpCompanyScreen extends StatefulWidget {
  const SignUpCompanyScreen({super.key});

  @override
  State<SignUpCompanyScreen> createState() => _SignUpCompanyScreenState();
}

class _SignUpCompanyScreenState extends State<SignUpCompanyScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context1) {
    return Consumer<SignUpCompanyProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 150), () => value.onReady(context)),
          child: PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) => value.popInvoke(didPop, context),
              child: LoadingComponent(
                  child: Scaffold(
                      appBar: AppBarCommon(
                        title: translations!.signUp,
                        onTap: () {
                          value.onBack(context);
                          // value.documentModel = '';
                          // documentList = [];
                          // route.pop(context);
                        },
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                            controller: value.controller,
                            child: Column(children: [
                              // SignupLinearProgressbar(
                              //     pageIndex: isFreelancer
                              //         ? value.fPageIndex
                              //         : value.pageIndex),
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
                                                /*  value.pageIndex == 0
                                                      ? translations!
                                                          .companyDetails
                                                      : value.pageIndex == 1
                                                          ? translations!
                                                              .companyLocation
                                                          :*/ translations!
                                                              .providerDetails)
                                              .toUpperCase(),
                                          style: appCss.dmDenseMedium16.textColor(
                                              appColor(context)
                                                  .appTheme
                                                  .darkText)),
                                      const DottedLines()
                                          .paddingSymmetric(vertical: Insets.i20),
                                     /* value.pageIndex == 0
                                          ? const SignUpOne()
                                          : value.pageIndex == 1
                                              ? SignUpTwo(sync: this)
                                              : */const SignUpThree()
                                    ]).paddingSymmetric(vertical: Insets.i20)
                              ]).paddingSymmetric(horizontal: Insets.i20),
                              ButtonCommon(
                                      title: /*value.pageIndex == 0 ||
                                              value.pageIndex == 1
                                          ? translations!.next
                                          : */translations!.finish,
                                      onTap: () => value.onNext(context))
                                  .paddingSymmetric(
                                      horizontal: Insets.i20,
                                      vertical: Insets.i20)
                            ])),
                      )))));
    });
  }
}
