import 'dart:convert';

import '../models/response_object.dart';
import 'package:http/http.dart';

class NetworkCaller {
  static Future<ResponseObject> getRequest(String url) async {
    final Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body);
      return ResponseObject(
          isSuccess: true, statusCode: 200, responseBody: decodeResponse);
    }else {
      return ResponseObject(
          isSuccess: false,
          statusCode: response.statusCode,
          responseBody: '');
    }
  }
}
