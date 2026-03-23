import 'dart:convert';
import 'dart:developer';
import 'package:fixit_provider/providers/common_providers/notification_provider.dart';

import '../../config.dart';
import '../../screens/app_pages_screens/app_setting_screen/layouts/theme_layout.dart';
import '../../screens/app_pages_screens/app_setting_screen/layouts/currency_bottom_sheet.dart';

class AppSettingProvider with ChangeNotifier {
  int selectIndex = 0;
  bool isNotification = true;
  final SharedPreferences sharedPreferences;

  AppSettingProvider(this.sharedPreferences);

  //fetch height
  heightMQ(context) {
    double height = MediaQuery.of(context).size.height;
    return height;
  }

  //fetch width
  widthMQ(context) {
    double width = MediaQuery.of(context).size.width;
    return width;
  }

  showLayoutTheme(context) async {
    showDialog(
      context: context,
      builder: (context1) {
        return const AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: Insets.i20),
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(SmoothRadius(
                  cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
          content: ThemeSelect(),
        );
      },
    );
  }

  // app setting list tap data
  onTapData(context, index) {
    log("dsf");
    if (index == 0) {
      showLayoutTheme(context);
      // showDialog(context: context, builder: (context) => AlertDialog(content: ,),);
      // } else if (index == 2) {
      //   currencyBottomSheet(context);
    } else if (index == 2) {
      route.pushNamed(context, routeName.changeLanguage);
    } else if (index == 3) {
      route.pushNamed(context, routeName.changePassword);
    }
  }

  //on notification tap
  Future<void> onNotification(val, context) async {
    isNotification = val;
    sharedPreferences.setBool(session.isNotification, isNotification);
    if (isNotification) {
      CustomNotificationController().initNotification(context);
    }
    notifyListeners();
  }

  // on back function
  onBack() {
    notifyListeners();
  }

  //currency selection
  onChangeButton(index) async {
    selectIndex = index;

    notifyListeners();
  }

  //currency update
  onUpdate(context, CurrencyModel data) async {
    log("asdasd ");

    SharedPreferences pref = await SharedPreferences.getInstance();
    currency(context).priceSymbol = data.symbol.toString();
    final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
    currencyData.currency = data;
    currencyData.currencyVal = (data.exchangeRate!);
    log("currencyData.currencyVal::${currencyData.currencyVal}");
    currencyData.notifyListeners();

    await pref.setString(session.priceSymbol, currency(context).priceSymbol);
    Map<String, dynamic> cc = await currencyData.currency!.toJson();
    await pref.setString(session.currency, jsonEncode(cc));
    await pref.setDouble(session.currencyVal, currencyData.currencyVal);
    notifyListeners();

    route.pop(context);
  }

  currencyBottomSheet(context) {
    if (currency(context).currency != null) {
      selectIndex = currencyList.indexWhere(
          (element) => element.symbol == currency(context).currency!.symbol);
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context2) {
          return CurrencyBottomSheet();
        },
      );
    } else {
      selectIndex = 0;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context2) {
          return CurrencyBottomSheet();
        },
      );
    }
  }

  onReady(context) async {
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    commonApi.getCurrency();
  }
}
