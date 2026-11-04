import 'package:edemand_partner/app/generalImports.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    required this.imageUrl,
    final Key? key,
    this.width,
    this.height,
    this.fit,
    this.isFile,
    this.avoidImageCache = true,
  }) : super(key: key);
  final String imageUrl;
  final double? width, height;
  final BoxFit? fit;
  final bool? isFile;
  final bool avoidImageCache;

  @override
  Widget build(final BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      if (imageUrl.endsWith('.svg')) {
        return SvgPicture.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
        );
      }
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      );
    }
    return imageUrl.endsWith('.svg')
        ? SvgPicture.network(
            imageUrl,
            fit: fit ?? BoxFit.fill,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(
              context.colorScheme.accentColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (final BuildContext context) => Center(
              child: CustomSvgPicture(
                svgImage: AppAssets.placeholder,
                width: width,
                height: height,
                boxFit: BoxFit.contain,
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) {
              return CustomContainer(
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.contain,
                ),
              );
            },
            maxWidthDiskCache: avoidImageCache ? 500 : null,
            maxHeightDiskCache: avoidImageCache ? 500 : null,
            memCacheWidth: avoidImageCache ? 150 : null,
            memCacheHeight: avoidImageCache ? 150 : null,
            width: width,
            height: height,
            fit: fit ?? BoxFit.contain,
            errorWidget: (BuildContext context, String url, final error) =>
                Center(
                  child: Center(
                    child: CustomSvgPicture(
                      svgImage: AppAssets.noImageFound,
                      width: width,
                      height: height,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                ),
            placeholder: (final BuildContext context, final String url) =>
                Center(
                  child: CustomSvgPicture(
                    svgImage: AppAssets.placeholder,
                    width: width,
                    height: height,
                    boxFit: BoxFit.cover,
                  ),
                ),
          );
  }
}
