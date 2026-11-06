import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pacial_2/config/api/api_client.dart';
import 'package:pacial_2/config/router/router_config.dart';
import 'package:pacial_2/config/theme/app_theme.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/providers/cart_provider.dart';
import 'package:pacial_2/providers/language_provider.dart';
import 'package:pacial_2/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Sin reintentos automáticos: un 403 o 404 se muestra de una vez.
  final container = ProviderContainer(retry: (_, _) => null);

  // Si el refresh token también venció, se vuelve al login.
  ApiClient.onSessionExpired = () {
    container.invalidate(cartProvider);
    appRouter.goNamed('login');
  };

  runApp(
    UncontrolledProviderScope(container: container, child: const MainApp()),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.themeData(isDark: false),
      darkTheme: AppTheme.themeData(isDark: true),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
