import 'package:edemand_partner/app/generalImports.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static Dio _createDio() {
    final backend = Uri.tryParse(domain);
    if (backend == null || backend.scheme != 'https' || backend.host.isEmpty) {
      throw ApiException('serviceUnavailable');
    }
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    if (kDebugMode) dio.interceptors.add(CurlLoggerInterceptor());
    return dio;
  }

  //headers
  static Map<String, dynamic> headers({bool includeAuth = true}) {
    final String jwtToken = HiveRepository.getUserToken;
    final lang = HiveRepository.getCurrentLanguage();

    if (kDebugMode) {
      print("token is $jwtToken");
    }

    final headers = <String, dynamic>{};

    if (includeAuth) {
      headers["Authorization"] = "Bearer $jwtToken";
    }

    if (lang?.languageCode != null && lang!.languageCode.isNotEmpty) {
      headers["Content-Language"] = lang.languageCode;
    }

    if (HiveRepository.isHandymanSession) {
      headers["User-type"] = "handyman";
    }

    return headers;
  }

  static Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> parameter,
    required bool useAuthToken,
  }) async {
    try {
      final Dio dio = _createDio();

      final FormData formData = FormData.fromMap(
        parameter,
        ListFormat.multiCompatible,
      );
      if (kDebugMode) {
        print("API is $url \n pra are $parameter \n ");
      }
      final Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: headers(includeAuth: useAuthToken),
        ),
      );

      if (kDebugMode) {
        print("API is $url \n pra are $parameter \n response is $response");
      }
      // if (response.data['error']) {
      //   throw ApiException(response.data['message']);
      // }
      return Map.from(response.data);
    } on FormatException catch (e) {
      if (kDebugMode) {
        print("error API is $url");

        print("error is ${e.message}");
      }
      throw ApiException(e.message);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("error API is $url");

        print("error is ${e.response} ${e.message}");
      }
      if (e.response?.statusCode == 401) {
        UiUtils.authenticationError = true;
        throw ApiException('authenticationFailed');
      } else if (e.response?.statusCode == 500) {
        throw ApiException('internalServerError');
      }
      throw ApiException(
        e.error is SocketException
            ? 'noInternetFound'
            : 'somethingWentWrongTitle',
      );
    } on ApiException catch (e) {
      throw ApiException(e.toString());
    } catch (e) {
      if (kDebugMode) {
        print("api ${e.toString()}");
      }
      throw ApiException('somethingWentWrongTitle');
    }
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Dio dio = _createDio();
      final Response response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers(includeAuth: useAuthToken)),
      );

      if (response.data['error'] == true) {
        throw ApiException(response.data['code'].toString());
      }

      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        UiUtils.authenticationError = true;
        throw ApiException('authenticationFailed');
      } else if (e.response?.statusCode == 500) {
        throw ApiException('internalServerError');
      }
      throw ApiException(
        e.error is SocketException
            ? 'noInternetFound'
            : 'somethingWentWrongTitle',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('somethingWentWrongTitle');
    }
  }

  static Future<List<int>> downloadAPI({
    required final String url,
    required final Map<String, dynamic> parameter,
    required final bool useAuthToken,
    final bool? isInvoiceAPI,
  }) async {
    try {
      final Dio dio = _createDio();
      final FormData formData = FormData.fromMap(
        parameter,
        ListFormat.multiCompatible,
      );

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            ...headers(includeAuth: useAuthToken),
            'Accept': 'application/pdf',
          },
          responseType: ResponseType.bytes,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        UiUtils.authenticationError = true;
        throw ApiException("authenticationFailed");
      } else if (e.response?.statusCode == 500) {
        throw ApiException("internalServerError");
      } else if (e.response?.statusCode == 503) {
        throw ApiException("internalServerError");
      }
      throw ApiException(
        e.error is SocketException ? "noInternetFound" : "somethingWentWrong",
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException("somethingWentWrong");
    }
  }
}
