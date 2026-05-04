import 'dart:developer';
import 'dart:io';

import '../../../../config.dart';

class ServicemenProfileLayout extends StatelessWidget {
  final bool? isFilePath;
  final Color? color;
  final String? image;
  const ServicemenProfileLayout({super.key,this.isFilePath = false,this.color, this.image });

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddServicemenProvider>(context);

    return Container(
        alignment: Alignment.center,
        height: Sizes.s90,
        width: Sizes.s90,
        decoration: BoxDecoration(
          color: color ?? appColor(context).appTheme.stroke,
            border: Border.all(
                color:
                appColor(context).appTheme.whiteColor,
                width: 4),
            shape: BoxShape.circle,
            image: isFilePath == true ? DecorationImage(
                fit: BoxFit.cover,
                image:  FileImage(
                    File(value.profileFile!.path))) : image != null? DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(image!))  :DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(eImageAssets.noImageFound3))),

    )
        .paddingOnly(top: Insets.i12)
        .inkWell(onTap: () => value.onImagePick(context, true));
  }
}
