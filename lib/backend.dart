import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'config.dart';

class BackendApi {
  static Uri _uri(String path) {
    final base = AppConfig.backendBaseUrl.replaceAll(RegExp(r'/+$'), '');
    return Uri.parse('$base$path');
  }

  static Future<bool> waitUntilReady({Duration timeout = const Duration(seconds: 25)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      try {
        final r = await http.get(_uri('/health')).timeout(const Duration(seconds: 4));
        if (r.statusCode == 200) return true;
      } catch (_) {}
      await Future.delayed(const Duration(seconds: 1));
    }
    return false;
  }

  static Future<Map<String, dynamic>> processFile({
    required File file,
    required String lang,
  }) async {
    final req = http.MultipartRequest('POST', _uri('/process'));
    req.fields['lang'] = lang;
    req.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamed = await req.send().timeout(const Duration(seconds: 60));
    final body = await streamed.stream.bytesToString();
    final data = json.decode(body) as Map<String, dynamic>;
    if (streamed.statusCode >= 400) {
      throw Exception(data['message'] ?? 'Error');
    }
    return data;
  }
}
