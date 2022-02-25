import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getNotice({bool isMain=false}) async {
  var response = await http.get(Uri.parse(baseUrl + (isMain ? pathNoticeMain : pathNotice)));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    return null;
  }
  return null;
}