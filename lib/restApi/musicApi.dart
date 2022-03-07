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

getNewMusic({required int userId}) async {
  String query = '/new?user_id=$userId';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getRecMusic({required int userId}) async {
  String query = '/rec?user_id=$userId';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getRecArtist({required int userId}) async {
  String query = '/rec/love?user_id=$userId';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getRecMusicArtist({required int userId, required String artist, contain=0}) async {
  String query = '?user_id=$userId&artist=$artist&contain=$contain';
  var response = await http.get(Uri.parse('$baseUrl$pathMusicRecArtist$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

getChart({required int userId}) async {
  String query = '/chart?user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathMusic$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}