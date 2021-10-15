import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getMusic({int id = 0, required int userId, String? type}) async {
  String query = (type == null ? '' : '/${type!}') + '?id=${id.toString()}&user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathLogin$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == false) return;
    return responseBody['body'];
  }
  else {
    return null;
  }
}

