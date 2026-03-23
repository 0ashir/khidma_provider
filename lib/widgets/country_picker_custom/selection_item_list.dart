import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../config.dart';
import 'layouts/country_theme.dart';

class SelectionList extends StatefulWidget {
  const SelectionList(this.elements, this.initialSelection,
      {super.key,
        this.appBar,
        this.theme,
        this.countryBuilder,
        this.useUiOverlay = true,
        this.useSafeArea = false});

  final PreferredSizeWidget? appBar;
  final List elements;
  final CountryCodeCustom? initialSelection;
  final CountryTheme? theme;
  final Widget Function(BuildContext context, CountryCodeCustom)?
  countryBuilder;
  final bool useUiOverlay;
  final bool useSafeArea;

  @override
  SelectionListState createState() => SelectionListState();
}

class SelectionListState extends State<SelectionList> {
  late List countries;
  final TextEditingController _controller = TextEditingController();
  ScrollController? _controllerScroll;
  var diff = 0.0;

  var posSelected = 0;
  var height = 0.0;
  dynamic sizeHeightContainer;
  dynamic heightscroller;
  dynamic text;
  dynamic oldtext;
  final itemSizeHeight = 50.0;
  double _offsetContainer = 0.0;

  bool isShow = true;

  @override
  void initState() {
    countries = widget.elements;
    countries.sort((a, b) {
      return a.name.toString().compareTo(b.name.toString());
    });
    _controllerScroll = ScrollController();
    _controllerScroll!.addListener(_scrollListener);
    super.initState();
  }

  void _sendDataBack(BuildContext context, CountryCodeCustom initialSelection) {
    Navigator.pop(context, initialSelection);
  }

  final List _alphabet =
  List.generate(26, (i) => String.fromCharCode('A'.codeUnitAt(0) + i));

  @override
  Widget build(BuildContext context) {
    if (widget.useUiOverlay) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: appColor(context).appTheme.whiteBg,
        statusBarIconBrightness:
            appColor(context).appTheme.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: appColor(context).appTheme.whiteBg,
        systemNavigationBarIconBrightness:
            appColor(context).appTheme.isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: !kIsWeb
            ? (appColor(context).appTheme.isDark
                ? Brightness.dark
                : Brightness.light)
            : Brightness.light,
      ));
    }
    height = MediaQuery.of(context).size.height;
    Widget scaffold = Scaffold(
      appBar: widget.appBar,
      body: Container(
        color: appColor(context).appTheme.fieldCardBg,
        child: LayoutBuilder(builder: (context, contrainsts) {
          diff = height - contrainsts.biggest.height;
          heightscroller = (contrainsts.biggest.height) / _alphabet.length;
          sizeHeightContainer = (contrainsts.biggest.height);
          return Stack(
            children: <Widget>[
              CustomScrollView(
                controller: _controllerScroll,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.theme?.searchText ?? 'SEARCH',
                            style: appCss.dmDenseMedium12.textColor(
                                widget.theme?.labelColor ??
                                    appColor(context).appTheme.darkText),
                          ),
                        ),
                        Container(
                          color: appColor(context).appTheme.whiteBg,
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 0, top: 0, right: 15),
                              hintText:
                              widget.theme?.searchHintText ?? "Search...",
                              hintStyle: appCss.dmDenseMedium14
                                  .textColor(appColor(context).appTheme.lightText),
                            ),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).appTheme.darkText),
                            onChanged: _filterElements,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.theme?.lastPickText ?? 'LAST PICK',
                            style: appCss.dmDenseMedium12.textColor(
                                widget.theme?.labelColor ??
                                    appColor(context).appTheme.darkText),
                          ),
                        ),
                        Container(
                          color: appColor(context).appTheme.whiteBg,
                          child: Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: Image.asset(
                                widget.initialSelection!.flagUri!,
                                width: 32.0,
                              ),
                              title: Text(
                                widget.initialSelection!.name!,
                                style: appCss.dmDenseMedium14
                                    .textColor(appColor(context).appTheme.darkText),
                              ),
                              trailing: const Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Icon(Icons.check, color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return widget.countryBuilder != null
                          ? widget.countryBuilder!(
                          context, countries.elementAt(index))
                          : getListCountry(countries.elementAt(index));
                    }, childCount: countries.length),
                  )
                ],
              ),
              if (isShow == true)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onVerticalDragUpdate: _onVerticalDragUpdate,
                    onVerticalDragStart: _onVerticalDragStart,
                    child: Container(
                      height: 20.0 * 30,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(_alphabet.length,
                                  (index) => _getAlphabetItem(index))
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
    return widget.useSafeArea ? SafeArea(child: scaffold) : scaffold;
  }

  Widget getListCountry(CountryCodeCustom e) {
    return Container(
      height: 50,
      color: appColor(context).appTheme.whiteBg,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Image.asset(
            e.flagUri!,
            width: 30.0,
          ),
          title: Text(
            e.name!,
            style: TextStyle(color: appColor(context).appTheme.darkText),
          ),
          onTap: () {
            _sendDataBack(context, e);
          },
        ),
      ),
    );
  }

  _getAlphabetItem(int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            posSelected = index;
            text = _alphabet[posSelected];
            if (text != oldtext) {
              for (var i = 0; i < countries.length; i++) {
                if (text.toString().compareTo(
                    countries[i].name.toString().toUpperCase()[0]) ==
                    0) {
                  _controllerScroll!.jumpTo((i * itemSizeHeight) + 10);
                  break;
                }
              }
              oldtext = text;
            }
          });
        },
        child: Container(
          width: 40,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == posSelected
                ? widget.theme?.alphabetSelectedBackgroundColor ?? Colors.blue
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            _alphabet[index],
            textAlign: TextAlign.center,
            style: (index == posSelected)
                ? TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.theme?.alphabetSelectedTextColor ??
                    appColor(context).appTheme.whiteColor)
                : TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: widget.theme?.alphabetTextColor ??
                        appColor(context).appTheme.darkText),
          ),
        ),
      ),
    );
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      countries = widget.elements
          .where((e) =>
      e.code.contains(s) ||
          e.dialCode.contains(s) ||
          e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 &&
          (_offsetContainer + details.delta.dy) <=
              (sizeHeightContainer - heightscroller)) {
        _offsetContainer += details.delta.dy;
        posSelected =
            ((_offsetContainer / heightscroller) % _alphabet.length).round();
        text = _alphabet[posSelected];
        if (text != oldtext) {
          for (var i = 0; i < countries.length; i++) {
            if (text
                .toString()
                .compareTo(countries[i].name.toString().toUpperCase()[0]) ==
                0) {
              _controllerScroll!.jumpTo((i * itemSizeHeight) + 15);
              break;
            }
          }
          oldtext = text;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _offsetContainer = details.globalPosition.dy - diff;
  }

  _scrollListener() {
    int scrollPosition =
    (_controllerScroll!.position.pixels / itemSizeHeight).round();
    if (scrollPosition < countries.length) {
      String? countryName = countries.elementAt(scrollPosition).name;
      setState(() {
        posSelected =
            countryName![0].toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
      });
    }

    if ((_controllerScroll!.offset) >=
        (_controllerScroll!.position.maxScrollExtent)) {}
    if (_controllerScroll!.offset <=
        _controllerScroll!.position.minScrollExtent &&
        !_controllerScroll!.position.outOfRange) {}
  }
}
