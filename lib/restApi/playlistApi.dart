import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getPlaylist({required int userId}) async {
  var query = '?user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathPlaylist$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    return null;
  }
  return null;
}

getPlaylistCount({required int userId}) async {
  var query = '/count?user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathPlaylist$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    return null;
  }
  return null;
}

postPlaylist({required int userId, required String title, int visible=0, String emoji=''}) async {
  var requestBody = Map();
  requestBody['user_id'] = userId.toString();
  requestBody['title'] = title;
  requestBody['visible'] = visible.toString();
  requestBody['emoji'] = emoji;

  var response = await http.post(Uri.parse('$baseUrl$pathPlaylist'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return true;
    }
    return null;
  }
  return null;
}

deletePlaylist({required int id}) async {
  var requestBody = Map();
  requestBody['id'] = id.toString();

  var response = await http.delete(Uri.parse('$baseUrl$pathPlaylist'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return responseBody['body'];
    }
    return null;
  }
  return null;
}

patchPlaylist({required int id, required String title, required String emoji}) async {
  var requestBody = Map();
  requestBody['id'] = id.toString();
  requestBody['title'] = title;
  requestBody['emoji'] = emoji;

  var response = await http.patch(Uri.parse('$baseUrl$pathPlaylist'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) {
      return true;
    }
    return null;
  }
  return null;
}

postPlaylistFromCuration({required int userId, required int curationId}) async {
  var requestBody = Map();
  requestBody['user_id'] = userId.toString();
  requestBody['curation_id'] = curationId.toString();

  var response = await http.post(Uri.parse('$baseUrl$pathPlaylist$pathCuration'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}