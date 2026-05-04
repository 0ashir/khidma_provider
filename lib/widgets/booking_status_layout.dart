import '../config.dart';

class BookingStatusLayout extends StatelessWidget {
  final String? title;
  final Color? color;
  const BookingStatusLayout({super.key,this.title,this.color});

  @override
  Widget build(BuildContext context) {
    return Text(language(context, title!),style: appCss.dmDenseMedium11.textColor(appColor(context).appTheme.whiteColor)).paddingSymmetric(vertical: Insets.i4,horizontal: Insets.i12).decorated(
        color: color ?? appColor(context).appTheme.online,
        borderRadius: BorderRadius.circular(AppRadius.r50)
    );
  }
}
