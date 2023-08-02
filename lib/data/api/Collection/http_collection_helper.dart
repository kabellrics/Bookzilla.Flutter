import 'dart:convert';
import 'package:bookzilla_flutter/data/api/Collection/collection.dart';
import 'package:http/http.dart' as http;

class HttpCollectionHelper {
  //http://192.168.1.17:800/api
  final String authority = '192.168.1.17:800';
  final String getAllPath = 'api/collection/read.php';
  final String updatePath = 'api/collection/update.php';

  String textToJson(String text) {
    var startIndex = text.indexOf('{');
    if (startIndex >= 0) {
      return text.substring(startIndex);
    } else {
      return '';
    }
  }

  Future<List<RemoteCollection>> getCollections() async {
    Uri uri = Uri.http(authority, getAllPath);
    http.Response result = await http.get((uri));
    if (result.statusCode == 200) {
      final jsonbody = textToJson(result.body);
      var responsecontainer =
          CollectionContainer.fromJson(jsonDecode(jsonbody));
      return responsecontainer.body;
    } else {
      throw Exception('Failed to get item.');
    }
  }
}
