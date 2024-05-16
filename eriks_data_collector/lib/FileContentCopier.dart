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

      File file = File('${directory.path}/answers.json');
      if (!await file.exists()) {
        await file.writeAsString('{}');
      }
      return file;
    } catch (e) {
      return null;
    }
  }

  static void _shareFile(File file) {
    Share.shareXFiles([XFile(file.path)], text: 'Your JSON file');
  }

  // Debug function for me to manually inject a change to previous
  // answers back into my phone (requires an answers_edit.json file to be put
  // into /assets/. The assets in pubspec.yaml also need to be updated)
  static Future<void> _copyAssetToFile() async {
    Directory directory = await getApplicationDocumentsDirectory();

    // Delete previous file
    try {
      File file = File('${directory.path}/answers.json');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Failed to delete {file}");
      return;
    }

    String fileContents = await rootBundle.loadString('assets/answers_edit.json');
    File file = File('${directory.path}/answers.json');
    await file.writeAsString(fileContents);
  }
}
