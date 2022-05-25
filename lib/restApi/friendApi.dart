import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocalist/restApi/userApi.dart';

import 'restApi.dart';

getFriend({required int userId}) async {
  var query = '?user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathFriend$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

postFriend({required int userId, required int responseUserId}) async {
  var requestBody = Map();
  requestBody['user_id'] = userId.toString();
  var temp = await getUser(id: responseUserId);
  if(temp != null) {
    print(temp);
    requestBody['email'] = temp['email'].toString();
  }
  else return false;

  var response = await http.post(Uri.parse('$baseUrl$pathFriend'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    print(responseBody);
    if(responseBody['status'] == true) return true;
    return false;
  }
  return false;
}

deleteFriend({required int id}) async {
  var requestBody = Map();
  requestBody['id'] = id.toString();

  var response = await http.delete(Uri.parse('$baseUrl$pathFriend'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return true;
    return false;
  }
  return false;
}

patchFriend({required int id}) async {
  var requestBody = Map();
  requestBody['id'] = id.toString();

  var response = await http.patch(Uri.parse('$baseUrl$pathFriend'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return true;
    return false;
  }
  return false;
}