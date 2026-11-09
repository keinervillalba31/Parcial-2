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
    // Con internet lento la petición espera hasta 15 s antes de dar error.
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
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
      final DioException? refreshError;
      (token, refreshError) = await _refresh();

      // Sin internet o API caída: no se cierra la sesión, se muestra el
      // error de conexión y el usuario puede reintentar.
      if (refreshError != null && _isNetworkError(refreshError)) {
        handler.next(refreshError);
        return;
      }
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
  /// Si falla la petición también devuelve el error para saber si fue la red.
  Future<(String?, DioException?)> _refresh() async {
    final refresh = await storage.read(key: StorageKeys.refreshToken);
    if (refresh == null || refresh.isEmpty) return (null, null);
    try {
      final response = await _plain.post(
        ApiConfig.refresh,
        data: {'refresh_token': refresh},
      );
      final auth = AuthModel.fromJson(response.data);
      await saveTokens(auth);
      return (auth.accessToken, null);
    } on DioException catch (e) {
      return (null, e);
    }
  }

  /// Error sin respuesta de la API (sin internet, timeout, servidor apagado).
  static bool _isNetworkError(DioException e) => e.response == null;
}
