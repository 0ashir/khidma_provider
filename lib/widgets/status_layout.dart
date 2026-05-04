import '../config.dart';

class BookingServiceStatusLayout extends StatelessWidget {
  final String? status, title;
  const BookingServiceStatusLayout({super.key, this.status, this.title});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: language(context,
                "${language(context, status ?? translations!.status)} : "),
            style: appCss.dmDenseSemiBold12
                .textColor(appColor(context).appTheme.red),
            children: [
          TextSpan(
              text: language(
                  context,
                  language(
                      context,
                      title ??
                          language(context, translations!.theProviderHas))),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.red))
        ])).paddingAll(Insets.i15).boxShapeExtension(
        radius: AppRadius.r8,
        color: appColor(context).appTheme.red.withOpacity(0.1));
  }
}
