


import 'package:fixit_provider/widgets/country_picker_custom/selection_item_list.dart';

import '../../config.dart';
import 'layouts/country_list_layout.dart';
import 'layouts/country_theme.dart';

List<Map> jsonList = countriesEnglish;

List element = jsonList
    .map((s) => CountryCodeCustom(
    name: s['name'],
    code: s['code'],
    dialCode: s['dial_code'],
    flagUri: 'assets/flags/${s['code'].toLowerCase()}.png'))
    .toList();

class CountryListPickCustom extends StatefulWidget {
  const CountryListPickCustom(
      {super.key,
        this.onChanged,
        this.initialSelection,
        this.appBar,
        this.pickerBuilder,
        this.countryBuilder,
        this.theme,
        this.useUiOverlay = true,
        this.useSafeArea = false});

  final String? initialSelection;
  final ValueChanged<CountryCodeCustom?>? onChanged;
  final PreferredSizeWidget? appBar;
  final Widget Function(BuildContext context, CountryCodeCustom? countryCode)?
  pickerBuilder;
  final CountryTheme? theme;
  final Widget Function(BuildContext context, CountryCodeCustom countryCode)?
  countryBuilder;
  final bool useUiOverlay;
  final bool useSafeArea;

  @override
  CountryListPickCustomState createState() {
    return CountryListPickCustomState();
  }
}

class CountryListPickCustomState extends State<CountryListPickCustom> {
  CountryCodeCustom? selectedItem;
  List elements = [];

  CountryListPickCustomState();

  @override
  void initState() {
    elements = element;
    setState(() {});
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
              (e) =>
          (e.code.toUpperCase() ==
              widget.initialSelection!.toUpperCase()) ||
              (e.dialCode == widget.initialSelection),
          orElse: () => elements[0] as CountryCodeCustom);
    } else {
      selectedItem = elements[0];
    }

    super.initState();
  }

  void _awaitFromSelectScreen(BuildContext context, PreferredSizeWidget? appBar,
      CountryTheme? theme) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectionList(elements, selectedItem,
                appBar: widget.appBar ??
                    AppBar(
                        backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                        title: Text(language(context, "Select Country"))),
                theme: theme,
                countryBuilder: widget.countryBuilder,
                useUiOverlay: widget.useUiOverlay,
                useSafeArea: widget.useSafeArea)));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged!(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          _awaitFromSelectScreen(context, widget.appBar, widget.theme);
        },
        child: widget.pickerBuilder != null
            ? widget.pickerBuilder!(context, selectedItem)
            : Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.theme?.isShowFlag ?? true == true)
                Flexible(
                    child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.asset(selectedItem!.flagUri!,
                            width: 32.0))),
              if (widget.theme?.isShowCode ?? true == true)
                Flexible(
                    child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(selectedItem.toString()))),
              if (widget.theme?.isShowTitle ?? true == true)
                Flexible(
                    child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 5.0),
                        child:
                        Text(selectedItem!.toCountryStringOnly()))),
              if (widget.theme?.isDownIcon ?? true == true)
                const Flexible(child: Icon(Icons.keyboard_arrow_down))
            ]));
  }
}
