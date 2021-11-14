import 'dart:convert';
import 'package:http/http.dart' as http;

import 'restApi.dart';

searchTitle({required int userId, required String input}) async {
  var query = '/title?user_id=${userId.toString()}&input=$input';

  var response = await http.get(Uri.parse('$baseUrl$pathSearch$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

searchArtist({required int userId, required String input}) async {
  var query = '/artist?user_id=${userId.toString()}&input=$input';

  var response = await http.get(Uri.parse('$baseUrl$pathSearch$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}

searchCuration({required int userId, required String input}) async {
  var query = '/curation?input=$input';

  var response = await http.get(Uri.parse('$baseUrl$pathSearch$query'));
  if(response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if(responseBody['status'] == true) return responseBody['body'];
    return null;
  }
  return null;
}