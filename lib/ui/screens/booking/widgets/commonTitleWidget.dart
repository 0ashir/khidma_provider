import 'package:flutter/material.dart';
import '../../../../app/generalImports.dart';

class CommonTitleWidget extends StatelessWidget {
  const CommonTitleWidget({super.key, required this.title, this.subTitle});

  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            subTitle!.translate(context: context),
            maxLines: 1,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Theme.of(context).colorScheme.lightGreyColor,
          ),
        ],
      ],
    );
  }
}

class CommonDividerWidget extends StatelessWidget {
  const CommonDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Theme.of(context).colorScheme.lightGreyColor,
    );
  }
}
