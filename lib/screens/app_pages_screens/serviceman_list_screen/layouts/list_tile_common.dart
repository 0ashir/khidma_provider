import 'dart:developer';

import '../../../../config.dart';

class ListTileLayout extends StatelessWidget {
  final CategoryModel? data;
  final dynamic booking;
  final bool? isBooking, isAddService;
  final int? index;
  final GestureTapCallback? onTap;
  final List? selectedCategory;

  const ListTileLayout(
      {super.key,
      this.data,
      this.onTap,
      this.selectedCategory,
      this.booking,
      this.isBooking = false,
      this.isAddService = false,
      this.index});

  @override
  Widget build(BuildContext context) {
    log("value.categories:$selectedCategory");
    // Helper function to check if category is selected
    bool isCategorySelected() {
      if (selectedCategory == null || selectedCategory!.isEmpty) {
        return false;
      }
      // Check if selectedCategory contains objects with 'id' or raw IDs
      final firstElement = selectedCategory!.first;
      if (firstElement is int) {
        return selectedCategory!.any((element) => element == data!.id);
      } else {
        // Assume CategoryModel or similar object with 'id'
        return selectedCategory!.any((element) => element.id == data!.id);
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IntrinsicHeight(
          child: Row(children: [
        data!.media != null && data!.media!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: data?.media?.first.originalUrl ?? "",
                imageBuilder: (context, imageProvider) => Container(
                    height: Sizes.s20,
                    width: Sizes.s20,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider))),
                errorWidget: (context, url, error) => Image.asset(
                    eImageAssets.noImageFound1,
                    height: Sizes.s20,
                    width: Sizes.s20))
            : Image.asset(eImageAssets.noImageFound1,
                height: Sizes.s20, width: Sizes.s20),
        VerticalDivider(
                indent: 4,
                endIndent: 4,
                width: 1,
                color: appColor(context).appTheme.stroke)
            .paddingSymmetric(horizontal: Insets.i12),
        Text(language(context, data!.title),
            style: appCss.dmDenseMedium14
                .textColor(appColor(context).appTheme.darkText))
      ])),
      /* Text(
          "${selectedCategory!.where((element) => element.toString() == data!.id.toString()).isNotEmpty}"),
      Text(
          "${selectedCategory!.where((element) => element.id.toString() == data!.id.toString()).isNotEmpty}"),
      Text("${isAddService == true}"), */
      CheckBoxCommon(isCheck: isCategorySelected(), onTap: onTap)
    ])
        .inkWell(onTap: onTap)
        .paddingSymmetric(vertical: Insets.i10, horizontal: Insets.i15)
        .boxBorderExtension(context, isShadow: true)
        .padding(horizontal: Insets.i20, bottom: Insets.i15);
  }
}
