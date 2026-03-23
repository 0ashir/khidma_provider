import '../../../../config.dart';

class ProofImageList extends StatelessWidget {
  const ProofImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddServiceProofProvider>(builder: (context1, value, child) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            value.serviceProofs != null &&
                    value.serviceProofs!.media!.isNotEmpty
                ? Row(
                        children: value.serviceProofs!.media!
                            .asMap()
                            .entries
                            .map((e) => AddServiceImageLayout(
                                onDelete: () => value.removeNetworkImage(e.key),
                                networkImage: e.value.originalUrl!))
                            .toList())
                    .paddingOnly(
                        left: rtl(context) ? 0 : Insets.i20,
                        right: rtl(context) ? Insets.i20 : 0)
                : Container(),
            value.proofList.isNotEmpty
                ? Row(
                        children: value.proofList
                            .asMap()
                            .entries
                            .map((e) => AddServiceImageLayout(
                                onDelete: () => value.onImageRemove(e.key),
                                image: e.value))
                            .toList())
                    .paddingOnly(
                        left: value.serviceProofs != null &&
                                value.serviceProofs!.media!.isNotEmpty
                            ? 0
                            : rtl(context)
                                ? 0
                                : Insets.i20,
                        right: rtl(context) ? Insets.i20 : 0)
                : Container(),
            AddNewBoxLayout(
                    title: translations!.addNew, onAdd: () => value.onImagePick(context))
                .paddingSymmetric(
                    horizontal: value.serviceProofs != null &&
                            value.serviceProofs!.media!.isNotEmpty
                        ? 0
                        : value.proofList.isNotEmpty
                            ? 0
                            : Insets.i20)
          ]));
    });
  }
}
