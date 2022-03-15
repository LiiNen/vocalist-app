import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getEvent() async {
  var response = await http.get(Uri.parse('$baseUrl$pathEvent'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getEventUser({required int userId}) async {
  var query = '?user_id=$userId';

  var response = await http.get(Uri.parse('$baseUrl$pathEvent/user$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

postEventUser({required int userId, required String phone}) async {
  var requestBody = Map();
  requestBody['user_id'] = userId.toString();
  requestBody['phone'] = phone;

  var response = await http.post(Uri.parse('$baseUrl$pathEvent/user'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return true;
  }
  return false;
}