import '../../../../config.dart';

class ServiceProofList extends StatelessWidget {
  final BookingModel? bookingModel;

  final Function(ServiceProofs)? onTap;

  const ServiceProofList({super.key, this.bookingModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...bookingModel!.serviceProofs!.asMap().entries.map((a) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(width: 180,
                  child: Text(a.value.title! + a.value.id.toString(),overflow: TextOverflow.fade,
                      style: appCss.dmDenseblack12
                          .textColor(appColor(context).appTheme.darkText)),
                ),
                Text(language(context, translations!.editProof),
                        style: appCss.dmDenseRegular14
                            .textColor(appColor(context).appTheme.primary))
                    .inkWell(onTap: () => onTap!(a.value))
              ]),
              const VSpace(Sizes.s10),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: a.value.media!
                          .asMap()
                          .entries
                          .map((e) => CachedNetworkImage(
                                imageUrl: e.value.originalUrl ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        height: Sizes.s70,
                                        width: Sizes.s70,
                                        decoration: ShapeDecoration(
                                            image:
                                                DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    SmoothBorderRadius(
                                                        cornerRadius:
                                                            AppRadius.r8,
                                                        cornerSmoothing: 1)))),
                                placeholder: (context, url) =>
                                    CommonCachedImage(
                                        height: Sizes.s70,
                                        width: Sizes.s70,
                                        radius: 8,
                                        image: eImageAssets.noImageFound1),
                                errorWidget: (context, url, error) =>
                                    CommonCachedImage(
                                        height: Sizes.s70,
                                        width: Sizes.s70,
                                        radius: 8,
                                        image: eImageAssets.noImageFound1),
                              ).paddingOnly(
                                  right: e.key != a.value.media!.length - 1
                                      ? Insets.i10
                                      : 0))
                          .toList())),
              if (a.key != bookingModel!.serviceProofs!.length - 1)
                Divider(height: 0, color: appColor(context).appTheme.stroke)
                    .paddingSymmetric(vertical: Insets.i20)
            ]))
      ],
    )
        .paddingAll(Insets.i15)
        .boxBorderExtension(context,
            color: appColor(context).appTheme.fieldCardBg)
        .paddingAll(Insets.i15)
        .boxBorderExtension(context,
            color: appColor(context).appTheme.whiteBg,
            bColor: appColor(context).appTheme.stroke);
  }
}
