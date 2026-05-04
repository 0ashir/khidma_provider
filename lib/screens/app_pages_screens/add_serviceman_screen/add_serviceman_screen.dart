import '../../../config.dart';

class AddServicemenScreen extends StatelessWidget {
  const AddServicemenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServicemenProvider>(builder: (context1, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: () => Future.delayed(const Duration(milliseconds: 100),
                () => value.onReady(context)),
            child: Scaffold(
                appBar: AppBarCommon(
                    onTap: () => value.onBack(context, true),
                    title: value.servicemanModel != null
                        ? translations!.editServicemen
                        : translations!.addServicemen),
                body: SingleChildScrollView(
                    child: Form(
                        key: value.addServiceManFormKey,
                        child: Column(children: [
                          const Column(children: [
                            AddServicemenProfileLayout(),
                            VSpace(Sizes.s35),
                            ServicemanOtherDetail()
                          ])
                              .paddingSymmetric(vertical: Insets.i20)
                              .boxShapeExtension(
                                  color: appColor(context).appTheme.fieldCardBg,
                                  radius: AppRadius.r12),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: ShapeDecoration(
                                color: appColor(context).appTheme.primary,
                                shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: AppRadius.r8,
                                        cornerSmoothing: 1))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                value.isEditServiceman ||
                                        value.isAddressServiceman
                                    ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        .center()
                                        .padding(vertical: Sizes.s5)
                                    : Text(
                                        language(
                                            context,
                                            value.servicemanModel != null
                                                ? translations!.update
                                                : translations!.addServicemen),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: appCss.dmDenseRegular16
                                            .textColor(appColor(context)
                                                .appTheme
                                                .whiteColor)),
                              ],
                            ),
                          ).inkWell(
                            onTap: () {
                              value.servicemanModel != null
                                  ? value.editData(context)
                                  : value.addData(context);
                            },
                          )
                              /*  ButtonCommon(
                                  title: value.servicemanModel != null
                                      ? translations!.update
                                      : translations!.addServicemen,
                                  onTap: () => value.servicemanModel != null
                                      ? value.editData(context)
                                      : value.addData(context)) */
                              .paddingOnly(top: Insets.i40, bottom: Insets.i10)
                        ]).paddingAll(Insets.i20))))),
      );
    });
  }
}
