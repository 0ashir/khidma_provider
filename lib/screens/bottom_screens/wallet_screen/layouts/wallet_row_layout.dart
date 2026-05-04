import '../../../../config.dart';

class WalletRowLayout extends StatelessWidget {
  final String? title, id;
  const WalletRowLayout({super.key, this.title, this.id});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(language(context, title!),
          style: appCss.dmDenseRegular12
              .textColor(appColor(context).appTheme.lightText)),
      Text(id!,
          style: appCss.dmDenseMedium14.textColor(language(context, title!) ==
                  language(context, translations!.status)
              ? appColor(context).appTheme.online
              : appColor(context).appTheme.darkText))
    ]).paddingOnly(bottom: Insets.i22);
  }
}
