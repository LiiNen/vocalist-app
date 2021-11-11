import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getLoveCount({required int userId}) async {
  var query = '/count?user_id=$userId';
  print(query);
  var response = await http.get(Uri.parse('$baseUrl$pathLove$query'));
  print(response.statusCode);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    return null;
  }
  return null;
}

getLoveList({required int userId}) async {
  var query = '/list?user_id=$userId';

  var response = await http.get(Uri.parse('$baseUrl$pathLove$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    return null;
  }
  return null;
}

postLove({required int musicId, required int userId}) async {
  var requestBody = Map();
  requestBody['music_id'] = musicId.toString();
  requestBody['user_id'] = userId.toString();

  var response = await http.post(Uri.parse('$baseUrl$pathLove'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return true;
    }
    return false;
  }
  return false;
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
      return true;
    }
    else return false;
  }
  else return false;
}