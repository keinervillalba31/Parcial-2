import 'package:dio/dio.dart';
import 'package:pacial_2/l10n/app_localizations.dart';

/// Convierte cualquier error en un mensaje para el usuario.
///
/// La API responde `{ status, message, errors }`: se usa su mensaje y, si hay
/// errores de validación por campo, se agregan al final.
String apiErrorMessage(Object error, AppLocalizations t) {
  if (error is! DioException) return t.errorUnexpected;

  final data = error.response?.data;
  if (data is Map && data['message'] is String) {
    final errors = data['errors'];
    final details = errors is Map
        ? errors.values.whereType<String>().toList()
        : const <String>[];
    final message = data['message'] as String;
    return details.isEmpty ? message : '$message: ${details.join(' · ')}';
  }

  final status = error.response?.statusCode;
  if (status == 401) return t.errorUnauthorized;
  if (status == 403) return t.errorForbidden;
  if (status != null) return t.errorServer(status);
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return t.errorTimeout;
  }
  return t.errorNetwork;
}
