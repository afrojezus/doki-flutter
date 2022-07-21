import 'dart:convert';
import 'package:doki/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:doki/data/models.dart';
import 'package:http/http.dart' as http;

class DokiAPI {
  List<File> files = <File>[];

  Future<void> load() async {
    try {
      files = await getAllFiles();
    } on Exception catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  Future<List<File>> getAllFiles() async {
    final response = await http.get(Uri.parse('${dokiBaseUrl}api/posts'));

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      var fileList = <File>[];
      for (var element in data) {
        var file = File.fromJson(element);
        if (!file.fileUrl.contains(RegExp(
            r'(^.*\.mp4|^.*\.webm|^.*\.mov|^.*\.mp3|^.*\.wav|^.*\.flac|^.*\.ogg)'))) {
          continue;
        }
        fileList.add(File.fromJson(element));
      }

      fileList.sort((a, b) => b.unixTime - a.unixTime);
      return fileList;
    } else {
      throw Exception('Failed to retrieve all files');
    }
  }
}
