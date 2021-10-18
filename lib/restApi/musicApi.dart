import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getMusic({int id = 0, required int userId}) async {
  String query = '?id=${id.toString()}&user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == false) return;
    return responseBody['body'];
  }
  else {
    return null;
  }
}

