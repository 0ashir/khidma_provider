import '../../../config.dart';

class AddPackageScreen extends StatefulWidget {
  const AddPackageScreen({super.key});

  @override
  State<AddPackageScreen> createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AddPackageProvider, SelectServiceProvider>(
        builder: (context1, value, selectVal, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 20), () => value.onInit(context)),
          child: PopScope(
              canPop: true,
              onPopInvoked: (bool didPop) => value.onBack(context),
              child: Scaffold(
                  appBar: ActionAppBar(
                      title: value.isEdit
                          ? translations!.editPackage
                          : translations!.addPackage,
                      onTap: () => value.onBackButton(context),
                      actions: [
                        if (value.isEdit)
                          CommonArrow(
                                  arrow: eSvgAssets.delete,
                                  onTap: () =>
                                      value.onPackageDelete(context, this))
                              .paddingSymmetric(horizontal: Insets.i20)
                      ]),
                  body: const AddPackageBodyWidget())));
    });
  }
}
