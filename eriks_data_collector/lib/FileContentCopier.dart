import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class FileContentCopier {
  static Future<String> readFileContent() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/answers.json');
      return await file.readAsString();
    } catch (e) {
      return 'Error reading the file.';
    }
  }

  static void _copyToClipboard(String content, BuildContext context) {
    Clipboard.setData(ClipboardData(text: content));
  }

  static void copy(BuildContext context) async {
    _copyToClipboard(await readFileContent(), context);
  }
}
