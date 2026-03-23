import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../config.dart';

class AddServiceImageLayout extends StatelessWidget {
  final XFile? image;
  final String? networkImage;
  final GestureTapCallback? onDelete;

  const AddServiceImageLayout(
      {super.key, this.image, this.onDelete, this.networkImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        networkImage == null
            ? Container(
                height: Sizes.s70,
                width: Sizes.s70,
                decoration: ShapeDecoration(
                    image: DecorationImage(
                        image: FileImage(File(image!.path)), fit: BoxFit.cover),
                    shape: RoundedRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: AppRadius.r8, cornerSmoothing: 1))))
            : /*CachedNetworkImage(
                imageUrl: networkImage!,
                imageBuilder: (context, imageProvider) => Container(
                    height: Sizes.s70,
                    width: Sizes.s70,
                    decoration: ShapeDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                        shape: RoundedRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: AppRadius.r8,
                                cornerSmoothing: 1)))),
                placeholder: (context, url) => CommonCachedImage(
                    height: Sizes.s70,
                    width: Sizes.s70,
                    image: eImageAssets.noImageFound1,
                    radius: 8),errorWidget: (context, url, error) => CommonCachedImage(
            height: Sizes.s70,
            width: Sizes.s70,
            image: eImageAssets.noImageFound1,
            radius: 8),
              )*/
            CommonImageLayout(
                radius: 8,
                assetImage: eImageAssets.noImageFound1,
                image: networkImage!,
                height: Sizes.s70,
                width: Sizes.s70),
        Container(
                padding: const EdgeInsets.all(Insets.i4),
                decoration: ShapeDecoration(
                    color: appColor(context).appTheme.darkText.withOpacity(0.5),
                    shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.only(
                            bottomLeft: SmoothRadius(
                                cornerRadius: AppRadius.r6, cornerSmoothing: 1),
                            topRight: SmoothRadius(
                                cornerRadius: AppRadius.r6,
                                cornerSmoothing: 1)))),
                child: Icon(CupertinoIcons.multiply,
                    color: appColor(context).appTheme.whiteColor,
                    size: Sizes.s14))
            .inkWell(onTap: onDelete)
      ],
    ).paddingOnly(
        right: rtl(context) ? 0 : Insets.i10,
        left: rtl(context) ? Insets.i10 : 0);
  }
}
