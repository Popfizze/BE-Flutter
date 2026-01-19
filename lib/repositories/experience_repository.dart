import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/experience.dart';

class ExperienceRepository {
  static const String _storageKey = 'experiences';

  /// Save all experiences to local storage
  Future<void> saveExperiences(List<Experience> experiences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = experiences.map((exp) => exp.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save experiences: $e');
    }
  }

  /// Load all experiences from local storage
  Future<List<Experience>> loadExperiences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Experience.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load experiences: $e');
    }
  }

  /// Clear all experiences from storage
  Future<void> clearExperiences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      throw Exception('Failed to clear experiences: $e');
    }
  }
}
