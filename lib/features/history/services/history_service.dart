import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_model.dart';

class HistoryService {
  static const String _storageKey = 'history_list';
  static final RxInt onHistoryUpdated = 0.obs;

  /// Saves the generated image to local storage and adds an entry to history.
  static Future<void> saveToHistory({
    required Uint8List imageBytes,
    required String title,
    required String featureName,
  }) async {
    try {
      // 1. Save Image to File System
      final directory = await getApplicationDocumentsDirectory();
      final historyDir = Directory('${directory.path}/history_images');
      if (!await historyDir.exists()) {
        await historyDir.create(recursive: true);
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${historyDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      // 2. Create History Model
      final newEntry = HistoryModel(
        path: file.path,
        title: title,
        tag: featureName,
        date: DateTime.now(),
      );

      // 3. Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(_storageKey);

      List<dynamic> currentList = [];
      if (historyJson != null) {
        currentList = jsonDecode(historyJson);
      }

      // Add to beginning of list
      currentList.insert(0, newEntry.toJson());

      await prefs.setString(_storageKey, jsonEncode(currentList));

      // Notify listeners
      onHistoryUpdated.value++;
    // ignore: empty_catches
    } catch (e) {
    }
  }

  /// Loads history items from local storage.
  static Future<List<HistoryModel>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString(_storageKey);

      if (historyJson == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(historyJson);
      return jsonList.map((e) => HistoryModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clears all history (Optional, for testing or user request)
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    // Ideally should also delete files, but keeping it simple for now.
  }
}
