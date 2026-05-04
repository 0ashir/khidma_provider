import 'dart:convert';

import '../../config.dart';

class CurrencyProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  double currencyVal = 1.0;

  CurrencyProvider(this.sharedPreferences) {
    dynamic prefData = jsonDecode(sharedPreferences
        .getString('currency')
        .toString()); /* selectedCurrency */
    currency = prefData;
    print("object: ${currency}");
    setVal();
  }

  dynamic currency;
  // double currencyVal =
  //     double.parse(appArray.currencyList[0]["USD"].toString()).roundToDouble();
  String priceSymbol = "\$";

  //currency set
  setVal() {
    // Ensure that the state update happens after the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currency != null) {
        priceSymbol = currency!.symbol!;
        currencyVal = double.parse(appArray.currencyList[0]["USD"].toString())
            .roundToDouble();
      }
      notifyListeners(); // Now safe to call after the build phase
    });
  }
  /*setVal() {
    priceSymbol = currency['symbol'].toString();

    if (currency["title"] == translations!.usDollar) {
      currencyVal = double.parse(currency["USD"].toString()).roundToDouble();
    } else if (currency["title"] == translations!.euro) {
      currencyVal = double.parse(currency["EUR"].toString()).roundToDouble();
    } else if (currency["title"] == translations!.inr) {
      currencyVal = double.parse(currency["INR"].toString()).roundToDouble();
    } else {
      currencyVal = double.parse(currency["POU"].toString()).roundToDouble();
    }

    //  currencyVal =   double.parse(currency["code"].toString());
    notifyListeners();
  }*/
}
