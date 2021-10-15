import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getCurationItem({required int curationId, String? type}) async {
  var query = (type == null ? '' : '/${type!}') + curationId.toString();

  var response = await http.get(Uri.parse('$baseUrl$pathCurationItem$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}