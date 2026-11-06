import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/providers/cart_provider.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/services/auth/auth_service.dart';

/// Cierra sesión y limpia el estado que no debe pasar al siguiente usuario.
Future<void> logout(BuildContext context, WidgetRef ref) async {
  await AuthService.logout();
  ref.invalidate(cartProvider);
  ref.invalidate(sneakerFilterProvider);
  if (context.mounted) context.goNamed('login');
}
