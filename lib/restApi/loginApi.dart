import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

loginApi({required String email, required String type}) async {
  var query = '?email=$email&type=$type';
  var response = await http.get(Uri.parse('$baseUrl$pathLogin$query'),);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

signupAction({required String email, required String name, required String type}) async {
  var requestBody = Map();
  requestBody['email'] = email;
  requestBody['name'] = name;
  requestBody['type'] = type;

  var response = await http.post(Uri.parse('$baseUrl$pathLogin'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}