import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pacial_2/model/auth/auth_model.dart';

const storage = FlutterSecureStorage();

class StorageKeys {
  static const token = 'token';
  static const refreshToken = 'refresh_token';
}

Future<void> saveTokens(AuthModel auth) async {
  await storage.write(key: StorageKeys.token, value: auth.accessToken);
  await storage.write(key: StorageKeys.refreshToken, value: auth.refreshToken);
}

Future<void> clearTokens() async {
  await storage.delete(key: StorageKeys.token);
  await storage.delete(key: StorageKeys.refreshToken);
}
