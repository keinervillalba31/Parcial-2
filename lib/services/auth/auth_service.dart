import 'package:pacial_2/config/api/api_client.dart';
import 'package:pacial_2/config/api/api_config.dart';
import 'package:pacial_2/helpers/jwt.dart';
import 'package:pacial_2/helpers/storage.dart';
import 'package:pacial_2/model/auth/auth_model.dart';
import 'package:pacial_2/model/user/user_model.dart';

/// Los errores se lanzan como DioException; las pantallas los convierten
/// en texto con `apiErrorMessage`.
class AuthService {
  static Future<void> login(String email, String password) async {
    final response = await ApiClient.dio.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
    );
    await saveTokens(AuthModel.fromJson(response.data));
  }

  /// Crea una cuenta de cliente y deja la sesión iniciada.
  static Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.dio.post(
      ApiConfig.register,
      data: {'name': name, 'email': email, 'password': password},
    );
    await saveTokens(AuthModel.fromJson(response.data));
  }

  static Future<UserModel> profile() async {
    final response = await ApiClient.dio.get(ApiConfig.profile);
    return UserModel.fromJson(response.data);
  }

  /// Rol guardado en el token (`ADMIN` / `CUSTOMER`), o `null` sin sesión.
  /// Lo usa el router para proteger rutas sin llamar a la API.
  static Future<String?> currentRole() async {
    final token = await storage.read(key: StorageKeys.token);
    if (token == null || token.isEmpty) return null;
    return decodeJwtPayload(token)['role'] as String? ?? '';
  }

  /// Borra los tokens del dispositivo y revoca el refresh token en la API.
  /// La revocación va en segundo plano: sin internet (o con internet lento)
  /// la sesión se cierra igual al instante y el token vencerá solo.
  static Future<void> logout() async {
    final refresh = await storage.read(key: StorageKeys.refreshToken);
    await clearTokens();
    if (refresh == null || refresh.isEmpty) return;
    // ignore(): si falla (sin internet) no se espera ni se reporta el error.
    ApiClient.dio
        .post(ApiConfig.logout, data: {'refresh_token': refresh})
        .ignore();
  }
}
