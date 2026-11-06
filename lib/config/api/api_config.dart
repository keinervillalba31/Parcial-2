import 'package:flutter/foundation.dart';

/// Configuración central de la API (SneakHub API en Spring Boot, carpeta /api).
class ApiConfig {
  static const int port = 8081;

  /// En el emulador de Android, "localhost" es el propio emulador:
  /// el PC se alcanza en 10.0.2.2. En web/escritorio sí es localhost.
  /// Para un celular físico, cambia esto por la IP de tu PC (ej: 192.168.1.10).
  static String get baseUrl {
    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';
    return 'http://$host:$port/api/v1';
  }

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String profile = '/auth/profile';
  static const String sneakers = '/sneakers';
  static const String brands = '/brands';
  static const String categories = '/categories';
  static const String orders = '/orders';

  /// Endpoints a los que nunca se les manda el token: si llevaran uno vencido,
  /// Spring Security respondería 401 aunque la ruta sea pública.
  static const Set<String> publicAuth = {login, register, refresh};
}
