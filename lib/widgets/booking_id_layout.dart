import '../config.dart';

class BookingIdLayout extends StatelessWidget {
  final String? id;
  const BookingIdLayout({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Text("#$id",
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.primary))
        .paddingSymmetric(vertical: Insets.i6, horizontal: Insets.i10)
        .decorated(
            color: appColor(context).appTheme.primary.withOpacity(0.15),
            borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r16)));
  }
}
