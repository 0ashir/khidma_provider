import '../config.dart';

class CommonCachedImage extends StatelessWidget {
  final double? height, width, radius;
  final String? image;
  final bool isCircle, isBorder, isAllBorderRadius;
  final BoxFit? boxFit;

  const CommonCachedImage(
      {super.key,
      this.height,
      this.width,
      this.image,
      this.isCircle = false,
      this.radius,
      this.boxFit,
      this.isBorder = false,
      this.isAllBorderRadius = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: isCircle
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: isBorder
                    ? Border.all(
                        color: appColor(context).appTheme.whiteColor, width: 4)
                    : null,
                image: DecorationImage(
                    image: AssetImage(image!), fit: BoxFit.cover))
            : ShapeDecoration(
                image: DecorationImage(
                    image: AssetImage(image!), fit: boxFit ?? BoxFit.cover),
                shape: SmoothRectangleBorder(
                    borderRadius: isAllBorderRadius
                        ? SmoothBorderRadius(
                            cornerRadius: radius ?? 1, cornerSmoothing: 1)
                        : const SmoothBorderRadius.only(
                            bottomRight: SmoothRadius(
                                cornerRadius: AppRadius.r20,
                                cornerSmoothing: 1),
                            bottomLeft: SmoothRadius(
                                cornerRadius: AppRadius.r20,
                                cornerSmoothing: 1)))));
  }
}

class CommonCachedNetworkImage extends StatelessWidget {
  final double? height, width, radius;
  final ImageProvider<Object>? image;
  final bool isCircle, isBorder, isAllBorderRadius;
  final BoxFit? boxFit;

  const CommonCachedNetworkImage(
      {super.key,
      this.height,
      this.width,
      this.image,
      this.isCircle = false,
      this.radius,
      this.boxFit,
      this.isBorder = false,
      this.isAllBorderRadius = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: isCircle
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: isBorder
                    ? Border.all(
                        color: appColor(context).appTheme.whiteColor, width: 4)
                    : null,
                image: DecorationImage(image: image!, fit: BoxFit.cover))
            : ShapeDecoration(
                image:
                    DecorationImage(image: image!, fit: boxFit ?? BoxFit.cover),
                shape: SmoothRectangleBorder(
                    borderRadius: isAllBorderRadius
                        ? SmoothBorderRadius(
                            cornerRadius: radius ?? 1, cornerSmoothing: 1)
                        : const SmoothBorderRadius.only(
                            bottomRight: SmoothRadius(
                                cornerRadius: AppRadius.r20,
                                cornerSmoothing: 1),
                            bottomLeft: SmoothRadius(
                                cornerRadius: AppRadius.r20,
                                cornerSmoothing: 1)))));
  }
}
