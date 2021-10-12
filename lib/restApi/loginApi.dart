import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

var _pathLogin = '/login';

loginApi({required String email, required String type}) async {
  var query = '?email=$email&type=$type';
  var response = await http.get(Uri.parse('$baseUrl$_pathLogin$query'),);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == false) return null;
    return responseBody['body'];
  }
  else {
    return null;
  }
}

signupAction({required String email, required String name, required String type}) async {
  var requestBody = Map();
  requestBody['email'] = email;
  requestBody['name'] = name;
  requestBody['type'] = type;

  var response = await http.post(Uri.parse('$baseUrl$_pathLogin'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    print(responseBody);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    else return null;
  }
  else return null;
}