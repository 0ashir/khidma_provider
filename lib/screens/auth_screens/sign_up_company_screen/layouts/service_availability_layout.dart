import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/auth_screens/sign_up_company_screen/layouts/zone_list.dart';

class ServiceAvailabilityLayout extends StatelessWidget {
  final TickerProvider? sync;
  const ServiceAvailabilityLayout({super.key, this.sync});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SignUpCompanyProvider, CommonApiProvider>(
        builder: (context1, value, api, child) {
      return Column(
        children: [
          // Text(
          //     language(context, translations!.serviceAvailability)
          //         .toUpperCase(),
          //     style: appCss.dmDenseSemiBold16
          //         .textColor(appColor(context).appTheme.darkText)),
          ContainerWithTextLayout(title: "${translations!.serviceAvailability}")
              .paddingOnly(bottom: Insets.i8, top: Insets.i20),
          // const VSpace(Sizes.s15),
          const ZoneDropDown(),
          /* SliderLayout(
                val: value.slider,
                onDragging: (handlerIndex, lowerValue, upperValue) =>
                    value.slidingValue(lowerValue))
                .padding(horizontal: Insets.i8, bottom: Insets.i10)
                .boxShapeExtension(color: appColor(context).appTheme.whiteBg)
                .paddingSymmetric(horizontal: Insets.i20),
            const VSpace(Sizes.s20),
            if (appArray.serviceAvailableAreaList.isEmpty)
              NoServiceAvailableLayout(
                  onTap: () => route.pushNamed(context, routeName.location,
                      arg: {"radius": value.slider}).then((e) {
                    value.notifyListeners();
                  })),
            if (appArray.serviceAvailableAreaList.isNotEmpty)
              ServiceAvailabilityList(sync: sync),
*/
          // const VSpace(Sizes.s30),
          // // const DottedLines(),
          // const VSpace(Sizes.s15),
        ],
      );
    });
  }
}
