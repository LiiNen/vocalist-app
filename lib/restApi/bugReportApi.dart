import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

postBugReport({required int userId, required String title, required String content}) async {
  var requestBody = Map();
  requestBody['user_id'] = userId.toString();
  requestBody['title'] = title;
  requestBody['content'] = content;

  var response = await http.post(Uri.parse('$baseUrl$pathBugReport'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

