import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/service_add_ons/add_service_add_ons_body_widget.dart';
import 'package:fixit_provider/widgets/action_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../providers/app_pages_provider/service_add_ons_provider.dart';

class CreateServiceAddOns extends StatelessWidget {
  const CreateServiceAddOns({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServiceAddOnsProvider>(
        builder: (context1, languageCtrl, value, child) {
      return Scaffold(
          appBar: ActionAppBar(
              title: translations?.addServiceAddOns,
              onTap: () {
                route.pop(context);
              } /* => value.onBackButton(context) */,
              actions: [
                /*   if (value.isEdit) */
                if (value.isEdit)
                  CommonArrow(
                          arrow: eSvgAssets.delete,
                          onTap:
                              () {} /* => value.onPackageDelete(context, this) */)
                      .paddingSymmetric(horizontal: Insets.i20)
              ]),
          body: const AddServiceAddOnsBodyWidget());
    });
  }
}
