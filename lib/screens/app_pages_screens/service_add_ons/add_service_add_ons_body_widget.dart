import 'dart:developer';
import 'dart:io';
import 'package:fixit_provider/providers/app_pages_provider/service_add_ons_provider.dart';
import 'package:fixit_provider/screens/app_pages_screens/service_add_ons/add_ons_description_from.dart';
import '../../../../config.dart';

class AddServiceAddOnsBodyWidget extends StatelessWidget {
  const AddServiceAddOnsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<LanguageProvider, ServiceAddOnsProvider,
            UserDataApiProvider>(
        builder: (context, languageCtrl, value, userData, child) {
      log("message=====${value.thumbFile?.path}");
      final mediaList = value.serviceAddOnsGet?.media;
      final imageUrl = (mediaList != null && mediaList.isNotEmpty)
          ? mediaList.first.originalUrl
          : null;

      final hasLocalImage = value.thumbFile?.path != null;
      final hasNetworkImage = imageUrl != null && imageUrl.isNotEmpty;

      return SingleChildScrollView(
          child: Form(
              key: value.addPackageFormKey,
              child: Column(children: [
                value.isEdit
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          ...languageCtrl.languageList
                              .asMap()
                              .entries
                              .toList()
                              .reversed
                              .map((e) {
                            int index = e.key;
                            bool isSelected =
                                languageCtrl.addSelectedIndex == index;
                            return GestureDetector(
                                onTap: () {
                                  log("kajghdajkdfh ${value.serviceAddOnsGet?.id}");
                                  languageCtrl.setSelectedIndex(
                                      index, e.value.locale.toString());
                                  log("Selected Language: ${languageCtrl.selectedLocaleService}");
                                  // Save the selected language persistently
                                  languageCtrl.sharedPreferences.setString(
                                      "selectedLocaleService",
                                      e.value.locale.toString());
                                  // value.clearData();
                                  // value.getServiceAddOnsId(
                                  //     context, value.serviceAddOnsGet?.id);
                                  // Notify listeners to update the UI
                                  languageCtrl.notifyListeners();
                                },
                                child: Row(children: [
                                  Container(
                                      height: Sizes.s16,
                                      width: Sizes.s24,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  e.value.flag.toString())))),
                                  const HSpace(Sizes.s6),
                                  Text(e.value.name.toString(),
                                      style: appCss.dmDenseRegular14.textColor(
                                          isSelected
                                              ? appColor(context)
                                                  .appTheme
                                                  .whiteColor // Change color when selected
                                              : appColor(context)
                                                  .appTheme
                                                  .darkText))
                                ])
                                    .decorated(
                                        color: isSelected
                                            ? appColor(context)
                                                .appTheme
                                                .primary // Highlight border
                                            : appColor(context)
                                                .appTheme
                                                .whiteBg,
                                        border: Border.all(
                                            color: appColor(context)
                                                .appTheme
                                                .stroke),
                                        borderRadius:
                                            BorderRadius.circular(Sizes.s8))
                                    .padding(
                                        horizontal: Sizes.s5,
                                        bottom: Sizes.s15));
                          })
                        ]))
                    : const SizedBox(),
                Stack(children: [
                  const FieldsBackground(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContainerWithTextLayout(
                            title:
                                language(context, "${translations!.service}")),
                        const VSpace(Sizes.s8),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.s15, vertical: Sizes.s15),
                            decoration: BoxDecoration(
                                color: appColor(context).appTheme.whiteBg,
                                border: Border.all(
                                    color: appColor(context).appTheme.stroke),
                                borderRadius: BorderRadius.circular(Sizes.s8)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(children: [
                                      Image.asset(eImageAssets.all,
                                          height: Insets.i20,
                                          color: appColor(context)
                                              .appTheme
                                              .lightText),
                                      const HSpace(Sizes.s12),
                                      Expanded(
                                        child: (value.selectedService != null
                                            ? Text(
                                                value.selectedService?.title ??
                                                    translations?.selectService ??
                                                    "",
                                                style: appCss.dmDenseLight14
                                                    .textColor(appColor(context)
                                                        .appTheme
                                                        .darkText),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis)
                                            : Text("Select Service",
                                                style: appCss.dmDenseLight14
                                                    .textColor(appColor(context)
                                                        .appTheme
                                                        .lightText),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      )
                                    ]),
                                  ),
                                  SvgPicture.asset(eSvgAssets.dropDown,
                                      colorFilter: ColorFilter.mode(
                                          appColor(context).appTheme.lightText,
                                          BlendMode.srcIn))
                                ])).inkWell(onTap: () {
                          log("aiudsioas ${allServiceList}");
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (context) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ServiceSelectionSheet(
                                        allServiceList: allServiceList,
                                        selectedServiceList: allServiceList,
                                        onSelect: (id, item, index) {
                                          value.onSelectService(id, item: item);
                                          Navigator.pop(context);
                                        }));
                              });
                        }).padding(horizontal: Sizes.s20),
                        const VSpace(Sizes.s15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const SmallContainer(),
                                const HSpace(Sizes.s20),
                                Text(
                                    "${language(context, translations?.thumbnailImage)} (${languageCtrl.selectedLocaleService})",
                                    //overflow: TextOverflow.ellipsis,
                                    style: appCss.dmDenseSemiBold14.textColor(
                                        appColor(context).appTheme.darkText))
                              ])
                            ]),
                        const VSpace(Sizes.s15),
                        (hasLocalImage || hasNetworkImage)
                            ? DottedBorder(
                                    color: appColor(context).appTheme.stroke,
                                    borderType: BorderType.RRect,
                                    radius:
                                        const Radius.circular(AppRadius.r10),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(AppRadius.r8)),
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: Sizes.s70,
                                            height: Sizes.s70,
                                            color: appColor(context)
                                                .appTheme
                                                .whiteBg,
                                            child: hasLocalImage
                                                ? Image.file(File(value.thumbFile!.path),
                                                    height: Sizes.s70,
                                                    width: Sizes.s70,
                                                    fit: BoxFit.cover)
                                                : CachedNetworkImage(
                                                    imageUrl: imageUrl!,
                                                    imageBuilder: (context, imageProvider) => Container(
                                                        height: Sizes.s70,
                                                        width: Sizes.s70,
                                                        decoration: ShapeDecoration(
                                                            shape: SmoothRectangleBorder(
                                                                borderRadius:
                                                                    SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 1)),
                                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                                                    placeholder: (context, url) => Container(height: Sizes.s200, width: Sizes.s200, decoration: ShapeDecoration(shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 1)), image: DecorationImage(image: AssetImage(eImageAssets.noImageFound2), fit: BoxFit.cover))),
                                                    errorWidget: (context, url, error) => Container(height: Sizes.s200, width: Sizes.s200, decoration: ShapeDecoration(shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 1)), image: DecorationImage(image: AssetImage(eImageAssets.noImageFound2), fit: BoxFit.cover)))))))
                                .inkWell(onTap: () {
                                value.onImagePick(context, true);
                              }).marginOnly(left: Insets.i20)
                            : AddNewBoxLayout(
                                title: translations!.addNew,
                                onAdd: () {
                                  value.onImagePick(context, true);
                                }).marginOnly(left: Insets.i20),
                        const VSpace(Sizes.s20),
                        const AddOnsDescriptionForm()
                      ]).paddingSymmetric(vertical: Insets.i20)
                ]),
                ButtonCommon(
                    isLoading: value.isLoading,
                    title: value.isEdit ? "Edit Service" : "Add service",
                    onTap: () {
                      value.isEdit
                          ? value.updateServiceAddOn(context)
                          : value.createServiceAddOn(context);
                    }).paddingOnly(top: Insets.i40, bottom: Insets.i30)
              ]).paddingSymmetric(horizontal: Insets.i20)));
    });
  }
}

class ServiceSelectionSheet extends StatelessWidget {
  final List<Services>? allServiceList;
  final List<Services>? selectedServiceList;
  final Function(int id, Services item, int index) onSelect;

  const ServiceSelectionSheet({
    super.key,
    required this.allServiceList,
    required this.selectedServiceList,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Select Services",
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: allServiceList?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(
                height: Sizes.s3,
              ),
              itemBuilder: (context, index) {
                final service = allServiceList![index];
                final isSelected =
                    selectedServiceList?.any((s) => s.id == service.id) ??
                        false;

                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(
                    service.title ?? "Select Service",
                    style: appCss.dmDenseLight14
                        .textColor(appColor(context).appTheme.darkText),
                  ),
                  // trailing: isSelected
                  //     ? const Icon(Icons.check_circle, color: Colors.green)
                  //     : null,
                  // tileColor: isSelected ? Colors.green.withOpacity(0.1) : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () => onSelect(service.id!, service, index),
                );
              },
            ),
          )
        ]));
  }
}
