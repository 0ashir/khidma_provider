import '../../../config.dart';

class AddExtraChargeScreen extends StatelessWidget {
  const AddExtraChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddExtraChargesProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
        onInit: () =>
            Future.delayed(Durations.short3).then((_) => value.onInit(context)),
        child: Scaffold(
            appBar: ActionAppBar(title: translations!.addExtraCharges),
            body: SingleChildScrollView(
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
                              title: language(
                                  context, translations!.chargesTitle)),
                          const VSpace(Sizes.s8),
                          TextFieldCommon(
                                  focusNode: value.chargeTitleFocus,
                                  hintText: language(
                                      context, translations!.enterServiceTitle),
                                  validator: (val) =>
                                      validation.commonValidation(context, val),
                                  controller: value.chargeTitleCtrl,
                                  prefixIcon: eSvgAssets.description)
                              .paddingSymmetric(horizontal: Insets.i20),
                          const VSpace(Sizes.s15),
                          ContainerWithTextLayout(
                              title: language(
                                  context, translations!.perServiceAmount)),
                          const VSpace(Sizes.s8),
                          TextFieldCommon(
                                  validator: (val) =>
                                      validation.commonValidation(context, val),
                                  keyboardType: TextInputType.number,
                                  focusNode: value.perServiceAmountFocus,
                                  hintText: language(
                                      context, translations!.addAmount),
                                  controller: value.perServiceAmountCtrl,
                                  prefixIcon: eSvgAssets.dollar)
                              .paddingSymmetric(horizontal: Insets.i20),
                          const VSpace(Sizes.s15),
                          ContainerWithTextLayout(
                              title: language(
                                  context, translations!.noOfServiceDone)),
                          const VSpace(Sizes.s8),
                          const ServiceDoneLayout(),
                          const VSpace(Sizes.s40),
                          ButtonCommon(
                                  title: translations!.addCharges,
                                  onTap: () => value.onAddCharge(context))
                              .paddingSymmetric(horizontal: Insets.i20)
                        ]).paddingSymmetric(vertical: Insets.i20),
                  )
                ])
              ]).paddingSymmetric(horizontal: Insets.i20),
            )),
      );
    });
  }
}
