import 'package:dio/dio.dart';
import 'package:pacial_2/config/api/api_config.dart';
import 'package:pacial_2/helpers/storage.dart';
import 'package:pacial_2/model/auth/auth_model.dart';

/// Cliente HTTP compartido por todos los servicios.
///
/// Agrega el token a cada petición y, si la API responde 401, intenta
/// renovarlo con el refresh token y repite la petición una vez.
class ApiClient {
  /// Se llama cuando la sesión no se pudo renovar (main.dart lleva al login).
  static void Function()? onSessionExpired;

  static BaseOptions get _options => BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  static final Dio dio = Dio(_options)..interceptors.add(_AuthInterceptor());
}

class _AuthInterceptor extends QueuedInterceptor {
  /// Dio sin interceptores para el refresh y el reintento (evita bucles).
  final _plain = Dio(ApiClient._options);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!ApiConfig.publicAuth.contains(options.path)) {
      final token = await storage.read(key: StorageKeys.token);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        ApiConfig.publicAuth.contains(request.path)) {
      handler.next(err);
      return;
    }

    // Si otra petición de la cola ya renovó el token, basta con reintentar.
    var token = await storage.read(key: StorageKeys.token);
    if (token == null || request.headers['Authorization'] == 'Bearer $token') {
      token = await _refresh();
    }

    if (token == null) {
      await clearTokens();
      ApiClient.onSessionExpired?.call();
      handler.next(err);
      return;
    }

    try {
      request.headers['Authorization'] = 'Bearer $token';
      handler.resolve(await _plain.fetch(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Devuelve el nuevo access token, o `null` si el refresh no es válido.
  Future<String?> _refresh() async {
    final refresh = await storage.read(key: StorageKeys.refreshToken);
    if (refresh == null || refresh.isEmpty) return null;
    try {
      final response = await _plain.post(
        ApiConfig.refresh,
        data: {'refresh_token': refresh},
      );
      final auth = AuthModel.fromJson(response.data);
      await saveTokens(auth);
      return auth.accessToken;
    } on DioException {
      return null;
    }
  }
}
