import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FileContentCopier {
  static Future<String> readAnswerFileContent() async {
      File? file = await _getAnswerFile();
      if (file != null) {
        return file.readAsString();
      }
      return 'Error reading the file.';
  }

  static void _copyToClipboard(String content, BuildContext context) {
    Clipboard.setData(ClipboardData(text: content));
  }

  static void copy(BuildContext context) async {
    _copyToClipboard(await readAnswerFileContent(), context);
  }

  static void share() async {
    File? file = await _getAnswerFile();
    if (file != null) {
      _shareFile(file);
    }
  }

  static Future<File?> _getAnswerFile() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/answers.json');
    } catch (e) {
      return null;
    }
  }

  static void _shareFile(File file) {
    Share.shareXFiles([XFile(file.path)], text: 'Your JSON file');
  }
}
