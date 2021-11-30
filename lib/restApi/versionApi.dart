import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getVersion() async {
  var response = await http.get(Uri.parse('$baseUrl$pathVersion'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body']['build'];
    return null;
  }
  return null;
}