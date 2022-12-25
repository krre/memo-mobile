import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  String ip = '';
  int port = 0;
  String key = '';

  Uri _makeUri(String endpoint) {
    return Uri.parse('http://$ip:$port/$endpoint');
  }

  Future<String> fetchName() async {
    final response = await http.get(_makeUri('name'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get database name');
    }
  }

  Future<dynamic> fetchNotes() async {
    final response = await http.get(_makeUri('notes'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get notes');
    }
  }
}
