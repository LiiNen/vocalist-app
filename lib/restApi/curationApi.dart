import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getCuration({int id=0}) async {
  var query = '?id=${id.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathCuration$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getCurationWithCtype({required int ctype_id}) async {
  var query = '/ctype?ctype_id=${ctype_id.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathCuration$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}