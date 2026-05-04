import '../../../config.dart';

class PackagesListScreen extends StatefulWidget {
  const PackagesListScreen({super.key});

  @override
  State<PackagesListScreen> createState() => _PackagesListScreenState();
}

class _PackagesListScreenState extends State<PackagesListScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PackageListProvider, DeleteDialogProvider>(
        builder: (context, value, deleteVal, child) {
      return StatefulWrapper(
        onInit: () {},
        child: Scaffold(
            appBar: ActionAppBar(title: translations!.packages, actions: [
              CommonArrow(
                      arrow: eSvgAssets.add,
                      onTap: () => route
                          .pushNamed(context, routeName.appPackage)
                          .then((e) => value.notifyListeners()))
                  .paddingSymmetric(horizontal: Insets.i20)
            ]),
            body: servicePackageList.isEmpty
                ? const CommonEmpty()
                : SingleChildScrollView(
                    child: Column(
                            children: servicePackageList
                                .asMap()
                                .entries
                                .map((e) => PackageLayout(
                                    onEdit: () async /* => */ {
                                      final packageDatails =
                                          Provider.of<PackageDetailProvider>(
                                              context,
                                              listen: false);

                                      await packageDatails
                                          .getServicePackageById(
                                              context, e.value.id);
                                      route.pushNamed(
                                          context, routeName.appPackage, arg: {
                                        'isEdit': true,
                                        "data": packageDatails.packageModel
                                      }).then((e) => value.notifyListeners());
                                    },
                                    onDelete: () => value.onPackageDelete(
                                        context, this, e.value.id),
                                    data: e.value,
                                    onToggle: (val) => value.onToggle(
                                        e.key, val, context, e.value.id)))
                                .toList())
                        .paddingSymmetric(horizontal: Insets.i20))),
      );
    });
  }
}
