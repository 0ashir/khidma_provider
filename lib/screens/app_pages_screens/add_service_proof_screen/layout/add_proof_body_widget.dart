import '../../../../config.dart';

class AddProofBodyWidget extends StatelessWidget {
  const AddProofBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProofProvider>(builder: (context1, value, child) {
      return SingleChildScrollView(
          child: Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          const FieldsBackground(),
          Form(
              key: value.formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerWithTextLayout(
                        title: language(context, translations!.title)),
                    const VSpace(Sizes.s8),
                    TextFieldCommon(
                            focusNode: value.titleFocus,
                            hintText:
                                language(context, translations!.enterTitle),
                            controller: value.titleCtrl,
                            prefixIcon: eSvgAssets.buildings)
                        .paddingSymmetric(horizontal: Insets.i20),
                    const VSpace(Sizes.s15),
                    ContainerWithTextLayout(
                        title: language(context, translations!.description)),
                    const VSpace(Sizes.s8),
                    Stack(children: [
                      TextFieldCommon(
                              focusNode: value.descriptionFocus,
                              isNumber: true,
                              controller: value.descriptionCtrl,
                              hintText: translations!.enterDetails!,
                              maxLines: 3,
                              minLines: 3,
                              isMaxLine: true)
                          .paddingSymmetric(horizontal: Insets.i20),
                      SvgPicture.asset(eSvgAssets.details,
                              fit: BoxFit.scaleDown,
                              colorFilter: ColorFilter.mode(
                                  !value.descriptionFocus.hasFocus
                                      ? value.descriptionCtrl.text.isNotEmpty
                                          ? appColor(context).appTheme.darkText
                                          : appColor(context).appTheme.lightText
                                      : appColor(context).appTheme.darkText,
                                  BlendMode.srcIn))
                          .paddingOnly(
                              left: rtl(context) ? 0 : Insets.i35,
                              right: rtl(context) ? Insets.i35 : 0,
                              top: Insets.i13)
                    ]),
                    const VSpace(Sizes.s15),
                    ContainerWithTextLayout(
                        title:
                            "${language(context, translations!.serviceImage)}*"),
                    const VSpace(Sizes.s8),
                    const ProofImageList(),
                    const VSpace(Sizes.s40),
                    ButtonCommon(
                            // isLoading: value.isAddServiceProof,
                            isLoading: value.isAddServiceProof ? true : false,
                            title: translations!.submit,
                            onTap: () => value.onSubmit(context))
                        .paddingSymmetric(horizontal: Insets.i20)
                  ]).paddingSymmetric(vertical: Insets.i20))
        ])
      ]).paddingSymmetric(horizontal: Insets.i20));
    });
  }
}
