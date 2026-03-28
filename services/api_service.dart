
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  static const url = "http://104.154.76.47:8000/inspect";

  static Future<String> inspectImage(String path) async {
    final req = http.MultipartRequest("POST", Uri.parse(url));
    req.files.add(await http.MultipartFile.fromPath('file', path));

    final resp = await req.send();
    final body = await resp.stream.bytesToString();
    return body;
  }
}
