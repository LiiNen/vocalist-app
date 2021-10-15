import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

postLove({required int musicId, required int userId}) async {
  var requestBody = Map();
  requestBody['music_id'] = musicId.toString();
  requestBody['user_id'] = userId.toString();

  var response = await http.post(Uri.parse('$baseUrl$pathLove'), body: requestBody);
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

deleteLove({required int musicId, required int userId}) async {
  var requestBody = Map();
  requestBody['music_id'] = musicId.toString();
  requestBody['user_id'] = userId.toString();

  var response = await http.delete(Uri.parse('$baseUrl$pathLove'), body: requestBody);
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