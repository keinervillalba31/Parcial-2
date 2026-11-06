import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pacial_2/providers/language_provider.dart';
import 'package:pacial_2/providers/theme_provider.dart';

/// Selector de idioma y botón de tema, arriba a la derecha.
class AuthTopBar extends ConsumerWidget {
  const AuthTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SegmentedButton<String>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              foregroundColor: scheme.onSurface,
              selectedForegroundColor: scheme.onPrimary,
              selectedBackgroundColor: scheme.primary,
              side: BorderSide(color: scheme.outline),
              visualDensity: VisualDensity.compact,
            ),
            segments: const [
              ButtonSegment(value: 'es', label: Text('ES')),
              ButtonSegment(value: 'en', label: Text('EN')),
            ],
            selected: {locale.languageCode},
            onSelectionChanged: (value) =>
                ref.read(languageProvider.notifier).changeLanguage(value.first),
          ),
          const SizedBox(width: 8),
          IconButton(
            color: scheme.onSurface,
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                key: ValueKey(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
