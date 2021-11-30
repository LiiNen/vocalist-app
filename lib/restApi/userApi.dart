import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getUser({required int id}) async {
  var query = '?id=$id';
  var response = await http.get(Uri.parse('$baseUrl$pathUser$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
  }
  return null;
}

patchUser({required int id, required String name, required String emoji}) async {
  var requestBody = Map();
  requestBody['id'] = id.toString();
  requestBody['name'] = name;
  requestBody['emoji'] = emoji;

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