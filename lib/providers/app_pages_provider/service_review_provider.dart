import 'dart:developer';

import '../../config.dart';

class ServiceReviewProvider with ChangeNotifier {
  String exValue = appArray.reviewLowHighList[0]["id"];
  String? settingExValue;
  bool isSetting = false;
  Services? services;
  List<Reviews> reviewList = [];
  bool isreviewLoading = false;
  double widget1Opacity = 0.0;

  // on back data set again
  onBack(context, isBack) {
    isSetting = false;
    widget1Opacity = 0.0;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  //service review filter option select
  onReview(val) {
    exValue = val;
    notifyListeners();
    log("services!.id::${services?.type}//$exValue");
    getReviewByServiceId(services?.id);
  }

  //provider review filter option select
  onSettingReview(val) {
    settingExValue = val;
    notifyListeners();
  }

  onTap(context, Reviews review) {
    if (review.service != null) {
      route.pushNamed(context, routeName.serviceDetails, arg: review.service);
    } else if (review.serviceman != null) {
      route.pushNamed(context, routeName.servicemanDetail,
          arg: {"detail": review.service!.id});
    }
  }

  //on page init data fetch
  onReady(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      isSetting = data['isSetting'] ?? false;
      if (data['service'] != null) {
        services = data['service'];
        getReviewByServiceId(services!.id);
      } else {
        // getMyReview(context);
      }
    } else {
      // getMyReview(context);
    }
    Future.delayed(const Duration(seconds: 3), () {
      widget1Opacity = 1;
      notifyListeners();
    });
    notifyListeners();
  }

  //get review by service id
  getReviewByServiceId(serviceId) async {
    reviewList = [];
    isreviewLoading = true;
    try {
      await apiServices
          .getApi(
              exValue == "0"
                  ? api.review
                  : exValue == "1"
                      ? "${api.review}?field=rating&sort=asc"
                      : "${api.review}?field=rating&sort=desc",
              [],
              isToken: true)
          .then((value) {
        if (value.isSuccess!) {
          isreviewLoading = false;
          for (var data in value.data) {
            if (!reviewList.contains(Reviews.fromJson(data))) {
              reviewList.add(Reviews.fromJson(data));
            }
            notifyListeners();
          }
          notifyListeners();
        }
      });
    } catch (e) {
      isreviewLoading = false;
      notifyListeners();
    }
  }

  //get review by user
  getMyReview(context) async {
    try {
      isreviewLoading = true;
      notifyListeners();
      await apiServices.getApi(api.review, [], isToken: true).then((value) {
        notifyListeners();
        if (value.isSuccess!) {
          isreviewLoading = false;
          List list = value.data;
          if (list.isNotEmpty) {
            reviewList = [];
          }
          for (var data in value.data) {
            if (!reviewList.contains(Reviews.fromJson(data))) {
              reviewList.add(Reviews.fromJson(data));
            }
            notifyListeners();
          }
          notifyListeners();
        } else {
          snackBarMessengers(context, message: value.message);
        }
      });
    } catch (e) {
      isreviewLoading = false;
      notifyListeners();
    }
  }
}
