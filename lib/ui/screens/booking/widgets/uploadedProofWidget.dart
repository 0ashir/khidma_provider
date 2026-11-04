import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';
import '../../../../utils/checkURLType.dart';

class UploadedProofWidget extends StatelessWidget {
  const UploadedProofWidget({
    super.key,
    required this.title,
    required this.proofData,
  });

  final String title;
  final List<dynamic> proofData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        CustomContainer(
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getTitle(title: title.translate(context: context)),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(proofData.length, (int index) {
                          return CustomContainer(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsetsDirectional.only(end: 10),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.lightGreyColor,
                            ),
                            child: CustomInkWellContainer(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.imagePreviewScreen,
                                  arguments: {
                                    'startFrom': index,
                                    'isReviewType': false,
                                    'dataURL': proofData,
                                  },
                                ).then((Object? value) {
                                  //locked in portrait mode only
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.portraitDown,
                                  ]);
                                });
                              },
                              child:
                                  UrlTypeHelper.getType(proofData[index]) ==
                                      UrlType.image
                                  ? CustomCachedNetworkImage(
                                      imageUrl: proofData[index],
                                      height: 50,
                                      width: 50,
                                    )
                                  : UrlTypeHelper.getType(proofData[index]) ==
                                        UrlType.video
                                  ? Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.accentColor,
                                      ),
                                    )
                                  : const CustomContainer(),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              _showDivider(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getTitle({required String title, String? subTitle}) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            maxLines: 1,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.blackColor,
          ),
          if (subTitle != null) ...[
            const SizedBox(height: 5),
            CustomText(
              subTitle,
              maxLines: 1,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Theme.of(context).colorScheme.lightGreyColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _showDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Theme.of(context).colorScheme.lightGreyColor,
    );
  }
}
