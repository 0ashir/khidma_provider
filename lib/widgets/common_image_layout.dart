import '../config.dart';

class CommonImageLayout extends StatelessWidget {
  final double? height, width, radius;
  final String? image, assetImage;
  final bool isCircle, isBorder, isAllBorderRadius;
  final BoxFit? boxFit;

  const CommonImageLayout(
      {super.key,
      this.height,
      this.width,
      this.radius,
      this.image,
      this.isCircle = false,
      this.boxFit,
      this.isBorder = false,
      this.isAllBorderRadius = true,
      this.assetImage});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: image!,
        imageBuilder: (context, imageProvider) => CommonCachedNetworkImage(
            height: height,
            width: width,
            isCircle: isCircle,
            image: imageProvider,
            isAllBorderRadius: isAllBorderRadius,
            radius: radius,
            boxFit: boxFit,
            isBorder: isBorder),
        placeholder: (context, url) => CommonCachedImage(
              height: height,
              width: width,
              image: assetImage,
              isCircle: isCircle,
              isBorder: isBorder,
              boxFit: boxFit,
              radius: radius,
              isAllBorderRadius: isAllBorderRadius,
            ),
        errorWidget: (context, url, error) => CommonCachedImage(
            height: height,
            width: width,
            image: assetImage,
            isCircle: isCircle));
  }
}
