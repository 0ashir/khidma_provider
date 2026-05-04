import 'package:fixit_provider/config.dart';

class FilterDropdown extends StatefulWidget {
  const FilterDropdown({super.key});

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  @override
  Widget build(BuildContext context) {
    final dash = Provider.of<UserDataApiProvider>(context, listen: false);
    // final value = Provider.of<BookingProvider>(context, listen: false);
    return Consumer<BookingProvider>(builder: (context, value, child) {
      return Container(
        width: Sizes.s180,
        decoration: ShapeDecoration(
            color: appColor(context).appTheme.fieldCardBg,
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1))),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value.selectedValue,
            isExpanded: true,
            /*  style: selectedValue == 'All'
              ? appCss.dmDenseMedium18
                  .textColor(appColor(context).appTheme.darkText)
              : appCss.dmDenseMedium15
                  .textColor(appColor(context).appTheme.lightText), */
            items: value.options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: appCss.dmDenseMedium15
                      .textColor(appColor(context).appTheme.darkText),
                ).padding(
                  horizontal: Insets.i12,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              value.setFilter(newValue);

              if (dash.bookingPage > 1) {
                dash.bookingPage--;
              }
              dash.isLoadingForBookingHistory = true;
              value.isLoadingForBookingHistory = true;

              dash.getBookingHistory(context, timeFilter: value.selectedValue);
            },
          ),
        ),
      );
    });
  }
}
