import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LocalDataSource {
  Future<void> saveCache(String key, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getCache(String key);
  Future<void> setDohBypass(bool value);
  bool getDohBypass();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences prefs;

  LocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveCache(String key, Map<String, dynamic> data) async {
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }

  @override
  Future<Map<String, dynamic>?> getCache(String key) async {
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  @override
  bool getDohBypass() {
    return prefs.getBool('doh_bypass') ?? true;
  }

  @override
  Future<void> setDohBypass(bool value) async {
    await prefs.setBool('doh_bypass', value);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main.dart');
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalDataSourceImpl(prefs: prefs);
});
