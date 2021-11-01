import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

patchUser({required int id, required String name}) async {
  var requestBody = Map();
  requestBody['id'] = id.toString();
  requestBody['name'] = name;
  
  var response = await http.patch(Uri.parse('$baseUrl$pathUser'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

deleteUser({required int id}) async {
  var requestBody = Map();
  requestBody['id'] = id.toString();

  var response = await http.delete(Uri.parse('$baseUrl$pathUser'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return true;
    return null;
  }
  return null;
}