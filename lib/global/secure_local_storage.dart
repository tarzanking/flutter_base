import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureLocalStorage extends GetxService {
  FlutterSecureStorage? _storage;

  FlutterSecureStorage get storage {
    _storage ??= const FlutterSecureStorage();
    return _storage!;
  }

  Map<String, String?> _allValues = {};

  static const _ACCESS_TOKEN = 'access_token';

  Future<SecureLocalStorage> init() async {
    _allValues = await storage.readAll();
    return this;
  }

  Future<void> writeAccessToken(String? accessToken) async {
    if (accessToken != this.accessToken) {
      _allValues[_ACCESS_TOKEN] = accessToken;
      await storage.write(key: _ACCESS_TOKEN, value: accessToken);
    }
  }

  String get accessToken => _getMapValue(_ACCESS_TOKEN);

  Future<void> deleteAccessToken() async {
    _allValues.remove(_ACCESS_TOKEN);
    await storage.delete(key: _ACCESS_TOKEN);
  }

  Future<void> deleteAll() async {
    _allValues.clear();
    await storage.deleteAll();
  }

  String _getMapValue(String key, {String defaultValue = ''}) {
    return _allValues.containsKey(key) ? (_allValues[key] ?? defaultValue) : defaultValue;
  }
}