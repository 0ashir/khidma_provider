import '../../../../config.dart';

class ServiceProviderLayout extends StatelessWidget {
  final List? list;
  final int? index;
  final String? title,name,rate,image;
  final GestureTapCallback? onTap;
  const ServiceProviderLayout({super.key,this.list,this.index,this.title,this.rate,this.name,this.image,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            onTap: onTap,
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Container(
                height: Sizes.s40,
                width: Sizes.s40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(image!)))),
            title: Text(language(context, title!),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).appTheme.lightText)),
            subtitle: Text(
                language(context, name!),
                style: appCss.dmDenseMedium14.textColor(
                    appColor(context).appTheme.darkText)),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(eSvgAssets.star),
                  const HSpace(Sizes.s4),
                  Text(rate!,
                      style: appCss.dmDenseMedium13
                          .textColor(appColor(context).appTheme.darkText))
                ])),
        if(index != list!.length - 1)
        const DividerCommon().paddingSymmetric(vertical: Insets.i10)
      ]
    );
  }
}
