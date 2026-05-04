import '../../../config.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailProvider>(builder: (context1, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          value.getArgument(context);
          if (didPop) return;
        },
        child: StatefulWrapper(
          onInit: () => Future.delayed(DurationsDelay.ms150)
              .then((_) => value.getArgument(context)),
          child: Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  leading: CommonArrow(
                          arrow: rtl(context)
                              ? eSvgAssets.arrowRight
                              : eSvgAssets.arrowLeft,
                          onTap: () => value.onBack(context, true))
                      .paddingAll(Insets.i8),
                  title: Text(language(context, translations!.profileDetails),
                      style: appCss.dmDenseBold18
                          .textColor(appColor(context).appTheme.darkText))),
              body: SingleChildScrollView(
                  child: Column(children: [
                const VSpace(Sizes.s20),
                Stack(children: [
                  const FieldsBackground(),
                  Column(children: [
                    Stack(alignment: Alignment.bottomCenter, children: [
                      Image.asset(eImageAssets.servicemanBg,
                              width: MediaQuery.of(context).size.width,
                              height: Sizes.s60)
                          .paddingOnly(bottom: Insets.i45),
                      Stack(alignment: Alignment.bottomRight, children: [
                        ProfilePicCommon(
                            image: value.imageFile,
                            imageUrl: userModel != null &&
                                    userModel!.media != null &&
                                    userModel!.media!.isNotEmpty &&
                                    userModel!.media![0].originalUrl != null
                                ? userModel!.media![0].originalUrl!
                                : null),
                        SizedBox(
                                child: SvgPicture.asset(eSvgAssets.edit,
                                        height: Sizes.s14)
                                    .paddingAll(Insets.i7))
                            .decorated(
                                color: appColor(context).appTheme.stroke,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: appColor(context).appTheme.primary))
                            .inkWell(onTap: () => value.showLayout(context))
                      ])
                    ]),
                    const VSpace(Sizes.s40),
                    TextFieldLayout()
                  ]).paddingSymmetric(vertical: Insets.i20)
                ]),
                const VSpace(Sizes.s40),
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
                          value.isUpdate
                              /*  ? const CircularProgressIndicator(color: Colors.white)
                              .center()
                              .padding(vertical: Sizes.s5)
                          : */
                              ? const Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(language(context, translations!.update),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: appCss.dmDenseRegular16.textColor(
                                      appColor(context).appTheme.whiteColor))
                        ])).inkWell(onTap: () => value.onUpdate(context))
                /*  ButtonCommon(
                        title: translations!.update,
                        onTap: () => value.onUpdate(context))
                    .marginOnly(bottom: Insets.i20) */
              ]).paddingSymmetric(horizontal: Insets.i20))),
        ),
      );
    });
  }
}
