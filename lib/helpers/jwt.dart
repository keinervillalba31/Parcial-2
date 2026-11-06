import 'dart:convert';

/// Lee los datos (claims) de un JWT. No valida la firma: eso lo hace la API.
Map<String, dynamic> decodeJwtPayload(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return {};
  try {
    final json = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final data = jsonDecode(json);
    return data is Map<String, dynamic> ? data : {};
  } catch (_) {
    return {};
  }
}
