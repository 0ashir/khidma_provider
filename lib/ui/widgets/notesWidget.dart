import 'package:flutter/material.dart';
import '../../app/generalImports.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({super.key, required this.remarks});

  final String remarks;

  @override
  Widget build(BuildContext context) {
    if (remarks == '') {
      return const SizedBox(height: 10);
    }

    return Column(
      children: [
        CustomContainer(
          color: Theme.of(context).colorScheme.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomSvgPicture(
                      svgImage: AppAssets.note,
                      color: context.colorScheme.accentColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: _getTitle(title: 'notesLbl'),
                    ),
                  ],
                ),
                CustomText(
                  remarks,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.lightGreyColor,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _getTitle({required String title, String? subTitle}) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title.translate(context: context),
            maxLines: 1,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.blackColor,
          ),
          if (subTitle != null) ...[
            const SizedBox(height: 5),
            CustomText(
              subTitle.translate(context: context),
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
}
