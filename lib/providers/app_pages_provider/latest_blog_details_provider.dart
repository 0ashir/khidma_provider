import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/scheduler.dart';

import '../../config.dart';
import '../../model/blog_details.dart';
import '../../model/dash_board_model.dart' show LatestBlog;

class LatestBLogDetailsProvider with ChangeNotifier {
  BlogDetails? data;
  LatestBlog? data1;

  onReady(context) {
    // dynamic arg = ModalRoute.of(context)!.settings.arguments;
    // data = arg;
    notifyListeners();
  }

  bool? isBlogList = false;
  var dio = Dio();

  Future<void> getBlogDetails(context, {dynamic id}) async {
    isBlogList = true;
    log("id::$id");
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? lang = pref.getString("selectedLocale") ?? "en";
      var response = await dio.get(
        "${api.blog}/$id",
        data: [],
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Lang': lang,
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        isBlogList = false;
        BlogDetails dddd = BlogDetails.fromJson(response.data);
        log("ddd:$dddd");
        data = dddd;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e, s) {
      isBlogList = false;
      log("EEEE getBlog : $e DATA////$s");
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  onHomeReady(context) {
    dynamic arg = ModalRoute.of(context)!.settings.arguments;
    data1 = arg;
    // id = data?.id.toString();
    // fetchBlog();
    notifyListeners();
  }

  onBack(context, isBack) {
    data = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onHomeBack(context) {
    data1 = null;
    route.pop(context);
    notifyListeners();
  }

  BlogModel? blog;
  String? id;
  bool isLoading = false;
/* Future<void> fetchBlog({id}) async {
    log("id===>$id");
    isLoading = true;
    notifyListeners();

    try {
      final response = await Dio().get("${api.blog}/$id");



      if (response.statusCode == 200 && response.data != null) {
        log("BLOG API CALLING ${response.data}");
        blog = BlogModel.fromJson(response.data);
        notifyListeners();
      }
    } catch (e, s) {
      print("Error fetching blog: $e==> $s");
    }

    isLoading = false;
    notifyListeners();
  }*/
}
