import 'dart:developer';

import 'package:http/http.dart' as http;

class NetworkUtility {
  Future<String>? fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      log("e.to :$e");
    }
    return "";
  }
}
