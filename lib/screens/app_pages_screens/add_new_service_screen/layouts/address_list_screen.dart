import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/layouts/location_layout.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddNewServiceProvider>(context);
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 80,
          title: Text(language(context, "my location"),
              style: appCss.dmDenseBold18
                  .textColor(appColor(context).appTheme.darkText)),
          centerTitle: true,
          leading: CommonArrow(
              arrow: eSvgAssets.arrowLeft,
              onTap: () {
                /* locationCtrl.onBack(); */
                route.pop(context);
              }).paddingAll(Insets.i8),
          actions: [
            CommonArrow(
                    arrow: eSvgAssets.add,
                    onTap: () => value.getLocation(context))
                .paddingSymmetric(horizontal: Insets.i20)
          ]),
      bottomNavigationBar: ButtonCommon(
        title: "Select Address",
        onTap: () {
          route.pop(context);
        },
      ).paddingAll(20),
      body: RefreshIndicator(
        onRefresh: () => value.getLocationData(context),
        child: ListView.builder(
          itemCount: value.locationData.length,
          itemBuilder: (context, index) {
            return LocationLayout(
              data: value.locationData[index],
              selectedIndex:
                  value.locationData[index].id == value.selectedIndex,
            ).inkWell(onTap: () {
              value.selectAddress(
                  value.locationData[index].id, value.locationData[index]);

              print(
                  "object -=-=-=-=-=-=-=-=-=-=123${value.locationData[index].id} ${value.locationData[index].id == value.selectedIndex} ${value.selectedIndex}");
            });
          },
        ),
      ),
    );
  }
}
