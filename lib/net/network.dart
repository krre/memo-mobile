import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  String ip = '';
  int port = 0;
  String token = '';

  Uri _makeUri(String endpoint) {
    return Uri.parse('http://$ip:$port/$endpoint');
  }

  Future<dynamic> fetchName() async {
    final response =
        await http.get(_makeUri('name'), headers: {"token": token});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.body.runes.toList()));
    } else {
      throw Exception('Failed to get database name');
    }
  }

  Future<dynamic> fetchNotes() async {
    final response =
        await http.get(_makeUri('notes'), headers: {"token": token});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.body.runes.toList()));
    } else {
      throw Exception('Failed to get notes');
    }
  }
}
