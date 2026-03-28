import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String baseUrl = "http://104.154.76.47:8000/inspect";

  Future<InspectionResult> inspectImage(File file) async {
    final request = http.MultipartRequest("POST", Uri.parse(baseUrl));
    request.files.add(
      await http.MultipartFile.fromPath("file", file.path),
    );

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    final jsonMap = json.decode(respStr);

    return InspectionResult.fromJson(jsonMap);
  }
}
