import 'dart:developer';

import 'package:fixit_provider/config.dart';

class CommissionHistoryProvider extends ChangeNotifier {
  bool isCompletedMe = false;

  onTapSwitch(val, context) async {
    isCompletedMe = val;
    notifyListeners();
    // showLoading(context);
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    await userApi.commissionHistory(isCompletedMe, context);
    userApi.notifyListeners();
    // hideLoading(context);
    notifyListeners();
  }
}
