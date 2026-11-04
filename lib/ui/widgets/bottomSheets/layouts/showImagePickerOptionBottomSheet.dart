import 'package:flutter/material.dart';

import '../../../../app/generalImports.dart';

class ShowImagePickerOptionBottomSheet extends StatelessWidget {
  const ShowImagePickerOptionBottomSheet({
    super.key,
    required this.title,
    required this.onCameraButtonClick,
    required this.onGalleryButtonClick,
  });

  final String title;
  final VoidCallback onCameraButtonClick;
  final VoidCallback onGalleryButtonClick;

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      title: title,
      child: Container(
        color: context.colorScheme.secondaryColor,
        padding: const EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomContainer(
                  borderRadius: UiUtils.borderRadiusOf10,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.lightGreyColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onCameraButtonClick();
                    },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Theme.of(context).colorScheme.blackColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'camera'.translate(context: context),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomContainer(
                  borderRadius: UiUtils.borderRadiusOf10,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.lightGreyColor,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                      onGalleryButtonClick();
                    },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 30,
                          color: Theme.of(context).colorScheme.blackColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'gallery'.translate(context: context),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
