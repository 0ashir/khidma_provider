import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';
import '../../../../utils/location.dart';
import '../../../screens/auth/map.dart';

class LocationInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cityController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final TextEditingController addressController;
  final FocusNode cityFocus;
  final FocusNode latitudeFocus;
  final FocusNode longitudeFocus;
  final FocusNode addressFocus;

  const LocationInfo({
    Key? key,
    required this.formKey,
    required this.cityController,
    required this.latitudeController,
    required this.longitudeController,
    required this.addressController,
    required this.cityFocus,
    required this.latitudeFocus,
    required this.longitudeFocus,
    required this.addressFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            CustomInkWellContainer(
              onTap: () async {
                UiUtils.removeFocus();

                String latitude = latitudeController.text.trim();
                String longitude = longitudeController.text.trim();
                if (latitude == '' && longitude == '') {
                  await GetLocation().requestPermission(
                    onGranted: (Position position) {
                      latitude = position.latitude.toString();
                      longitude = position.longitude.toString();
                    },
                    allowed: (Position position) {
                      latitude = position.latitude.toString();
                      longitude = position.longitude.toString();
                    },
                    onRejected: () {},
                  );
                }
                if (context.mounted) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => FetchUserCurrentLocationCubit(),
                        child: GoogleMapScreen(
                          latitude: latitude,
                          longitude: longitude,
                        ),
                      ),
                    ),
                  ).then((value) {
                    // Null when the picker is closed without choosing.
                    if (value is! Map) return;
                    latitudeController.text = value['selectedLatitude'];
                    longitudeController.text = value['selectedLongitude'];
                    addressController.text = value['selectedAddress'];
                    cityController.text = value['selectedCity'];
                  });
                }
              },
              child: CustomContainer(
                margin: const EdgeInsets.only(bottom: 15),
                height: 50,
                border: Border.all(
                  width: 0.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.lightGreyColor.withAlpha(50),
                ),
                borderRadius: UiUtils.borderRadiusOf10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.my_location_sharp,
                      color: Theme.of(context).colorScheme.accentColor,
                    ),
                    Text(
                      'chooseYourLocation'.translate(context: context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.accentColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.accentColor,
                    ),
                  ],
                ),
              ),
            ),
            CustomTextFormField(
              bottomPadding: 15,
              labelText: 'cityLbl'.translate(context: context),
              controller: cityController,
              currentFocusNode: cityFocus,
              nextFocusNode: latitudeFocus,
              validator: (String? cityValue) =>
                  Validator.nullCheck(context, cityValue),
            ),
            CustomTextFormField(
              bottomPadding: 15,
              labelText: 'latitudeLbl'.translate(context: context),
              controller: latitudeController,
              currentFocusNode: latitudeFocus,
              nextFocusNode: longitudeFocus,
              textInputType: TextInputType.number,
              validator: (String? latitude) =>
                  Validator.validateLatitude(context, latitude),
              allowOnlySingleDecimalPoint: true,
            ),
            CustomTextFormField(
              bottomPadding: 15,
              labelText: 'longitudeLbl'.translate(context: context),
              controller: longitudeController,
              currentFocusNode: longitudeFocus,
              nextFocusNode: addressFocus,
              textInputType: TextInputType.number,
              validator: (String? longitude) =>
                  Validator.validateLongitude(context, longitude),
              allowOnlySingleDecimalPoint: true,
            ),
            CustomTextFormField(
              bottomPadding: 15,
              labelText: 'addressLbl'.translate(context: context),
              controller: addressController,
              currentFocusNode: addressFocus,
              textInputType: TextInputType.multiline,
              expands: true,
              minLines: 3,
              validator: (String? addressValue) =>
                  Validator.nullCheck(context, addressValue),
            ),
          ],
        ),
      ),
    );
  }
}
