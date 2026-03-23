import 'dart:developer';

import '../../../../config.dart';

class FormServiceImageLayout extends StatelessWidget {
  const FormServiceImageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddNewServiceProvider>(context);

    return Consumer<LanguageProvider>(builder: (context, lang, child) {
      log("value.webThumbImage ${value.webThumbImage}");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContainerWithTextLayout(
              title: language(context,
                  "${language(context, translations!.serviceImages)} (${((value.services != null && value.services!.media != null && value.services!.media!.isNotEmpty ? value.services!.media!.length : 0) + appArray.serviceImageList.length)}/5) ${value.isEdit ? lang.selectedLocaleService : ""} *")),
          const VSpace(Sizes.s12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  if (value.services != null &&
                      value.services!.media != null &&
                      value.services!.media!.isNotEmpty)
                    ...value.services!.media!.asMap().entries.map((e) =>
                        e.value.collectionName == "thumbnail"
                            ? Container()
                            : e.value.collectionName == "image"
                                ? AddServiceImageLayout(
                                        networkImage: e.value.originalUrl!,
                                        onDelete: () => value
                                            .onRemoveNetworkServiceImage(false,
                                                index: e.key))
                                    .paddingOnly(right: Insets.i15)
                                : Container()),
                  if (appArray.serviceImageList.isNotEmpty)
                    ...appArray.serviceImageList.asMap().entries.map((e) =>
                        AddServiceImageLayout(
                            image: e.value,
                            onDelete: () => value.onRemoveServiceImage(false,
                                index: e.key))),
                  if (appArray.serviceImageList.length <= 4)
                    AddNewBoxLayout(
                        onAdd: () => value.onImagePick(context, false))
                ])),
            const VSpace(Sizes.s8),
            /*  Text(language(context, translations!.theMaximumImage),
                style: appCss.dmDenseRegular12
                    .textColor(appColor(context).appTheme.lightText)) */
          ]).paddingSymmetric(horizontal: Insets.i20),
          ContainerWithTextLayout(
                  title: language(context, "${translations!.thumbnailImage} *"))
              .paddingOnly(top: Insets.i24, bottom: Insets.i12),
          if (value.thumbImage != null && value.thumbImage != "")
            AddServiceImageLayout(
                    networkImage: value.thumbImage,
                    onDelete: () => value.onRemoveNetworkServiceImage(true))
                .paddingSymmetric(horizontal: Insets.i20),
          if (value.thumbImage == null || value.thumbImage == "")
            value.thumbFile != null
                ? AddServiceImageLayout(
                        image: value.thumbFile!,
                        onDelete: () => value.onRemoveServiceImage(true))
// =======
//                         onDelete: () => value.onRemoveWebServiceImage(false))

                    .paddingSymmetric(horizontal: Insets.i20)
                : AddNewBoxLayout(onAdd: () => value.onImagePick(context, true))
                    .paddingSymmetric(horizontal: Insets.i20),
          const VSpace(Sizes.s12),
          ContainerWithTextLayout(
              title: language(context,
                  "${language(context, "Web Images")} (${((value.services != null && value.services!.media != null && value.services!.media!.isNotEmpty ? value.services!.media!.length : 0) + appArray.webServiceImageList.length)}/5) *")),
          const VSpace(Sizes.s12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  if (value.services != null &&
                      value.services!.media != null &&
                      value.services!.media!.isNotEmpty)
                    ...value.services!.media!
                        .asMap()
                        .entries
                        .map((e) => e.value.collectionName == "web_thumbnail"
                            ? Container()
                            : e.value.collectionName == "web_images"
                                ? AddServiceImageLayout(
                                    networkImage: e.value.originalUrl!,
                                    onDelete: () {
                                      log("e.key::${e.key}");
                                      value.onRemoveNetworkServiceImage(false,
                                          index: e.key);
                                    }).paddingOnly(right: Insets.i15)
                                : Container()),
                  if (appArray.webServiceImageList.isNotEmpty)
                    ...appArray.webServiceImageList.asMap().entries.map((e) =>
                        AddServiceImageLayout(
                            image: e.value,
                            onDelete: () => value.onRemoveWebServiceImage(false,
                                index: e.key))),
                  if (appArray.webServiceImageList.length <= 4)
                    AddNewBoxLayout(
                        onAdd: () => value.onWebImagePick(context, false))
                ])),
            /* const VSpace(Sizes.s8),
            Text(language(context, translations!.theMaximumImage),
                style: appCss.dmDenseRegular12
                    .textColor(appColor(context).appTheme.lightText)) */
          ]).paddingSymmetric(horizontal: Insets.i20),
          ContainerWithTextLayout(
                  title: language(context, "${"Web Thumbnail Image"} *"))
              .paddingOnly(top: Insets.i24, bottom: Insets.i12),
          if (value.webThumbImage != null && value.webThumbImage != "")
            AddServiceImageLayout(
                    networkImage: value.webThumbImage,
                    onDelete: () => value.onRemoveNetworkWebServiceImage(true))
                .paddingSymmetric(horizontal: Insets.i20),
          if (value.webThumbImage == null || value.webThumbImage == "")
            value.webThumbFile != null
                ? AddServiceImageLayout(
                        image: value.webThumbFile!,
                        onDelete: () => value.onRemoveWebServiceImage(true))
                    .paddingSymmetric(horizontal: Insets.i20)
                : AddNewBoxLayout(
                        onAdd: () => value.onWebImagePick(context, true))
                    .paddingSymmetric(horizontal: Insets.i20),
          /*   const VSpace(Sizes.s8),
          Text(language(context, translations!.theMaximumImage),
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).appTheme.lightText))
              .paddingSymmetric(horizontal: Insets.i20), */
          ContainerWithTextLayout(
                  title: language(context, "${translations!.serviceName} *"))
              .paddingOnly(top: Insets.i24, bottom: Insets.i12),
          TextFieldCommon(
                  validator: (name) => validation.nameValidation(context, name),
                  focusNode: value.serviceNameFocus,
                  controller: value.serviceName,
                  hintText: translations!.enterName!,
                  prefixIcon: eSvgAssets.serviceName)
              .paddingSymmetric(horizontal: Insets.i20),
        ],
      );
    });
  }
}
