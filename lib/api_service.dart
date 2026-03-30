import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String baseUrl = "http://104.154.76.47:8000";

  Future<InspectionResult> inspect(File file) async {
    final uri = Uri.parse("$baseUrl/inspect");

    print("📤 Sending to: $uri");
    print("📤 File: ${file.path}");
    print("📤 Size: ${file.lengthSync()} bytes");

    final req = http.MultipartRequest("POST", uri);

    // Swagger requires field name "file"
    req.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );

    final streamed = await req.send().timeout(
      const Duration(seconds: 25),
      onTimeout: () {
        throw Exception("⏳ Server timed out. Check backend.");
      },
    );

    print("📥 Status: ${streamed.statusCode}");

    final body = await streamed.stream.bytesToString();
    print("📥 Body: $body");

    if (streamed.statusCode != 200) {
      throw Exception("❌ API Error: $body");
    }

    return InspectionResult.fromJson(jsonDecode(body));
  }
}
