import 'dart:io';

import '../config.dart';

class ProfilePicCommon extends StatelessWidget {
  final bool? isProfile;

  final String? imageUrl;
  final XFile? image;

  const ProfilePicCommon(
      {super.key, this.imageUrl, this.image, this.isProfile});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      image != null
          ? Container(
              height: Sizes.s88,
              width: Sizes.s88,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: FileImage(File(image!.path)), fit: BoxFit.cover),
                  border: Border.all(
                      color: isProfile == true
                          ? appColor(context)
                              .appTheme
                              .whiteBg
                              .withValues(alpha: 0.75)
                          : appColor(context).appTheme.trans,
                      width: isProfile == true ? 4 : 2,
                      style: BorderStyle.solid)))
          : imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  errorWidget: (context, url, error) => CommonCachedImage(
                      height: Sizes.s88,
                      width: Sizes.s88,
                      isCircle: true,
                      image: eImageAssets.noImageFound3),
                  placeholder: (context, url) => CommonCachedImage(
                      height: Sizes.s88,
                      width: Sizes.s88,
                      isCircle: true,
                      image: eImageAssets.noImageFound3),
                  imageBuilder: (context, imageProvider) =>
                      CommonCachedNetworkImage(
                          height: Sizes.s88,
                          width: Sizes.s88,
                          isCircle: true,
                          image: imageProvider),
                )
              : Container(
                  height: Sizes.s88,
                  width: Sizes.s88,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(eImageAssets.noImageFound3),
                          fit: BoxFit.cover),
                      border: Border.all(
                          color: isProfile == true
                              ? appColor(context)
                                  .appTheme
                                  .whiteBg
                                  .withOpacity(0.75)
                              : appColor(context).appTheme.trans,
                          width: isProfile == true ? 4 : 2,
                          style: BorderStyle.solid))),
      Container(
          height: isProfile == true ? Sizes.s82 : Sizes.s85,
          width: isProfile == true ? Sizes.s82 : Sizes.s85,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: appColor(context).appTheme.whiteBg,
                  width: isProfile == true ? 2 : 1,
                  style: BorderStyle.solid)))
    ]);
  }
}
