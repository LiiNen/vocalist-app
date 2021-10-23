import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getPlaylistItem({required int playlistId, required int userId, String? type}) async {
  var query = (type == null ? '' : '/$type')
      + '?playlist_id=${playlistId.toString()}&user_id=${userId.toString()}';

  var response = await http.get(Uri.parse('$baseUrl$pathPlaylistItem$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

postPlaylistItem({required int playlistId, required int musicId}) async {
  var requestBody = Map();
  requestBody['playlist_id'] = playlistId.toString();
  requestBody['music_id'] = musicId.toString();

  var response = await http.post(Uri.parse('$baseUrl$pathPlaylistItem'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(requestBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

deletePlaylistItem({required int playlistId, required int musicId}) async {
  var requestBody = Map();
  requestBody['playlist_id'] = playlistId.toString();
  requestBody['music_id'] = musicId.toString();

  var response = await http.delete(Uri.parse('$baseUrl$pathPlaylistItem'), body: requestBody);
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}