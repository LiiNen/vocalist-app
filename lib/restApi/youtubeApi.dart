import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

getYoutubeData({required String artist, required String title}) async {
  var keyword = '$artist $title';
  var query = '?key=$youtubeKey&q=$keyword&part=id&maxResults=1&type=video';

  var response = await http.get(Uri.parse('$youtubeUrl$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    return responseBody['items'][0]['id']['videoId'];
  }
  else return null;
}