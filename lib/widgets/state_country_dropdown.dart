import 'package:dropdown_search/dropdown_search.dart';

import '../config.dart';

class StateCountryDropdown extends StatelessWidget {
  final String? icon, hint;
  final ValueChanged? onChanged;
  final List? items;
  final dynamic selectedItem;

  final FormFieldValidator<dynamic>? validator;

  const StateCountryDropdown(
      {super.key, this.onChanged, this.items, this.selectedItem, this.icon, this.hint, this.validator});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            dropdownMenuTheme: const DropdownMenuThemeData(
                inputDecorationTheme:
                InputDecorationTheme(fillColor: Colors.cyan))),
        child: DropdownSearch(

            dropdownButtonProps: DropdownButtonProps(
                icon: SvgPicture.asset(eSvgAssets.dropDown,
                    colorFilter: ColorFilter.mode(
                        selectedItem != null ? appColor(context).appTheme
                            .darkText :
                        appColor(context).appTheme.lightText,
                        BlendMode.srcIn))),
            popupProps: const PopupProps.menu(
                showSearchBox: true, searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero
                )
            )
            ),
            onChanged: onChanged,
            items: items!,
            validator: validator,
            selectedItem: selectedItem,
            filterFn: (item, filter) {
              return item.name.toString().toLowerCase().contains(filter);
            },
            itemAsString: (item) => item.name,
            /* dropdownBuilder: (context, selectedItem) =>
            Text(selectedItem.title),*/
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: SvgPicture.asset(icon ?? eSvgAssets.country,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(
                            selectedItem != null ? appColor(context).appTheme
                                .darkText :
                            appColor(context).appTheme.lightText,
                            BlendMode.srcIn)),
                    fillColor: appColor(context).appTheme.whiteColor,
                    filled: true,
                    hintStyle: appCss.dmDenseRegular14.textColor(
                        appColor(context).appTheme.lightText),
                    errorStyle: appCss.dmDenseRegular12.textColor(
                        appColor(context).appTheme.red),
                    hintText: language(context, hint),
                    enabledBorder: CommonWidgetLayout().noneDecoration(),
                    border: CommonWidgetLayout().noneDecoration(),
                    focusedBorder: CommonWidgetLayout().noneDecoration(),
                    disabledBorder: CommonWidgetLayout().noneDecoration()))
        )
    );
  }
}
