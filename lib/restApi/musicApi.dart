import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getMusic({int id = 0, required int userId}) async {
  String query = '?id=${id.toString()}&user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getRecMusic({required int userId}) async {
  String query = '/rec?user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getRecMusicCluster({required int userId, required int cluster}) async {
  String query = '/rec/cluster?user_id=${userId.toString()}&cluster=${cluster.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}