import '../../../../config.dart';

class PersonalInfoRowLayout extends StatelessWidget {
  final String? icon,title,content;
  const PersonalInfoRowLayout({super.key,this.title,this.icon,this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(icon!,colorFilter: ColorFilter.mode(appColor(context).appTheme.lightText, BlendMode.srcIn)),
            const HSpace(Sizes.s6),
            Text(language(context, title!),style: appCss.dmDenseMedium12.textColor(appColor(context).appTheme.lightText))
          ]
        ),
        const VSpace(Sizes.s5),
        Text(language(context, content),style: appCss.dmDenseSemiBold14.textColor(appColor(context).appTheme.darkText))
      ]
    );
  }
}
