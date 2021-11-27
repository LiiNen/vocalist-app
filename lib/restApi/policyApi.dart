import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getPolicy({required int id}) async {
  var query = '?id=$id';
  var response = await http.get(Uri.parse('$baseUrl$pathPolicy$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    return null;
  }
  return null;
}