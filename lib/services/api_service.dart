import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/utils/toast_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'environment.dart';
import 'error/exceptions.dart';

class ApiServices {
  static var client = http.Client();
  final dio = Dio();
  static List<Map<String, String>> conversationHistory = [];

  //to get full path with paramiters
  static Future<String> getFullUrl(String apiName, List params) async {
    String url0 = "";
    if (params.isNotEmpty) {
      url0 = "$apiName?";
      for (int i = 0; i < params.length; i++) {
        url0 = '$url0${params[i]["key"]}=${params[i]["value"]}';
        if (i + 1 != params.length) url0 = "$url0&";
      }
    } else {
      url0 = apiName;
    }

    String url = '$apiUrl$url0';

    return url;
  }

  // Fetch paginated data
  Future<List<dynamic>> fetchPaginatedData(
      String apiName, int page, int pageSize) async {
    try {
      final response = await dio.get(
        '$apiName/booking',
        queryParameters: {
          'paginate': pageSize,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['data'] ?? [];
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

/*  Future<APIDataClass>*/
  getApi(String apiName, dynamic params,
      {isToken = false, isData = false, isMessage = true}) async {
    //default data to class
    APIDataClass apiData =
        APIDataClass(message: 'No data', isSuccess: false, data: '0');
    // log("message:::${apiData.data}");
    //Check For Internet
    bool isInternet = await isNetworkConnection();
    if (!isInternet) {
      log("isInternet:::$isInternet");
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    } else {
      try {
        //dio.options.headers["authtoken"] = authtoken;
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? token = pref.getString(session.accessToken);
        String? language = pref.getString("selectedLocale") ?? "english";
        log("token : $token");
        log("apiUrl CAll Name::$apiName");
        var response = await dio.get(
          apiName,
          data: params,
          options: Options(headers: isToken ? headersToken(token) : headers),
        );
        log("response.statusCode::${response.statusCode}");
        if (response.statusCode == 200) {
          log("message::;${response.data}");
          var responseData = response.data;
          if (isData) {
            apiData.message = isMessage
                ? apiName.contains("highest-ratings")
                    ? ""
                    : responseData["message"] ?? ""
                : "";
            apiData.isSuccess = true;
            apiData.data = responseData ?? "";
            return apiData;
          } else {
            apiData.message = responseData["message"] ?? "";
            apiData.isSuccess = true;
            apiData.data = apiName.contains("self")
                ? responseData['user']
                : responseData["data"];
            return apiData;
          }
        } else if (response.statusCode == 401) {
          NavigationService.pushNamedAndRemoveUntil(routeName.intro);
          pref.clear();
          userModel = null;
        } else {
          apiData.message = "No Internet Access";
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } catch (e) {
        apiData = await dioException(e);
        log("apiData  $apiName df:$apiData");
        return apiData;
      }
    }
  }

  Future<APIDataClass> dioException(e) async {
    APIDataClass apiData =
        APIDataClass(message: 'No data', isSuccess: false, data: '0');
    if (e is DioException) {
      if (e.type == DioExceptionType.badResponse) {
        final response = e.response;

        if (response!.data != null) {
          apiData.message = response.data['message'];
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        } else {
          apiData.message = response.data.toString();
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } else {
        final response = e.response;
        if (response != null && response.data != null) {
          final Map responseData = json.decode(response.data as String) as Map;
          apiData.message = responseData['message'] as String;
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        } else {
          log("EROROROROROR :$response");
          apiData.message = "";
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      }
    } else {
      apiData.message = "";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    }
  }

  Future<APIDataClass> postApi(String apiName, body,
      {isToken = false, isData = false}) async {
    //default data to class
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    } else {
      //dio.options.headers["authtoken"] = authtoken;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      String? language = pref.getString("selectedLocale");
      log("AUTH : $token");
      try {
        final response = await dio.post(apiName,
            data: body,
            options: Options(headers: isToken ? headersToken(token) : headers));
        log("RESPONJSE :1 ${body}");
        log("RESPONJSE :1 ${response.data}");

        var responseData = response.data;
        log("STA :${response.statusCode}");
        if (response.statusCode == 200) {
          log("message========> ${response.data}");
          //get responselogin

          if (apiName.contains("login") ||
              apiName.contains("register") ||
              apiName.contains("social/login") ||
              apiName.contains("social/verifyOtp")) {
            await pref.setString(
                session.accessToken, responseData['access_token']);
            //set data to class
            apiData.message =
                apiName.contains("login") || apiName.contains("social/login")
                    ? ""
                    : "Register Successfully";
            apiData.isSuccess = true;
            apiData.data = "";
            return apiData;
          } else {
            //set data to class
            log("RESPONJSE :2 ${response.data}");
            log("RESPONJSE :2 ${isData}");
            /* apiData.message = responseData["message"] ?? "";
            apiData.isSuccess = true;
            apiData.data = responseData["data"];
            return apiData;*/
            if (isData) {
              apiData.message = responseData["message"] ?? "";
              apiData.isSuccess = responseData["success"] ?? true;
              apiData.data = responseData;
              return apiData;
            } else {
              apiData.message = responseData["message"] ?? "";
              apiData.isSuccess = true;
              apiData.data = responseData["data"];
              return apiData;
            }
          }
        } else if (response.statusCode == 422) {
          Fluttertoast.showToast(msg: responseData["message"]);

          return apiData;
        } else {
          apiData.message = responseData["message"];
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } catch (e, s) {
        apiData = await dioException(e);
        log("message========> Body : $s");
        log("DDDD :${apiData.message}");
        return apiData;
      }
    }
  }

  Future<APIDataClass> deleteApi(String apiName, body,
      {isToken = false}) async {
    //default data to class
    APIDataClass apiData =
        APIDataClass(message: 'No data', isSuccess: false, data: '0');
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    } else {
      //dio.options.headers["authtoken"] = authtoken;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      String? language = pref.getString("selectedLocale");
      log("AUTH : $token");
      try {
        final response = await dio.delete(
          apiName,
          data: body,
          options: Options(headers: isToken ? headersToken(token) : headers),
        );
        var responseData = response.data;
        if (response.statusCode == 200) {
          //set data to class
          apiData.message = responseData["message"] ?? "";
          apiData.isSuccess = true;
          apiData.data = responseData["data"];
          return apiData;
        } else {
          apiData.message = responseData["message"];
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } catch (e) {
        apiData = await dioException(e);
        return apiData;
      }
    }
  }

  Future<APIDataClass> putApi(String apiName, body,
      {isToken = false, isData = false}) async {
    //default data to class
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    } else {
      //dio.options.headers["authtoken"] = authtoken;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      String? language = pref.getString("selectedLocale");
      log("AUTH Language : $language");

      try {
        final response = await dio.put(
          apiName,
          data: jsonEncode(body),
          options: Options(headers: isToken ? headersToken(token) : headers),
        );
        var responseData = response.data;
        if (response.statusCode == 200) {
          //get response

          if (isData) {
            //set data to class
            apiData.message = "";
            apiData.isSuccess = true;
            apiData.data = responseData;
            return apiData;
          } else {
            //set data to class

            apiData.message = responseData["message"] ?? "";
            apiData.isSuccess = true;
            apiData.data = responseData["data"];
            return apiData;
          }
        } else {
          apiData.message = responseData["message"];
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } catch (e, s) {
        print("object===========> $e,========> $s");
        apiData = await dioException(e);
        return apiData;
      }
    }
  }
}

Exception handleErrorResponse(http.Response response) {
  var data = jsonDecode(response.body);

  return RemoteException(
    statusCode: response.statusCode,
    message: data['message'] ?? response.statusCode == 422
        ? 'Validation failed'
        : 'Server exception',
  );
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static pushNamedAndRemoveUntil(String routeName) {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}
