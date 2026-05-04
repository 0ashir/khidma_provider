import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../../config.dart';

class JobRequestListProvider extends ChangeNotifier {
  List<JobRequestModel> jobRequestList = [];
  bool isPositionedRight = false;
  bool isAnimateOver = false;
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;

  onInit(context) async {
    onRefresh(context);
    /*jobRequestList = appArray.jobRequestList
         .map((e) => JobRequestModel.fromJson(e))
         .toList();*/

    notifyListeners();
    log("JOBB :${jobRequestList.length}");
  }

  onRefresh(context) async {
    notifyListeners();
    final dash = Provider.of<UserDataApiProvider>(context, listen: false);
    dash.getJobRequest(context);

    notifyListeners();
  }
}
