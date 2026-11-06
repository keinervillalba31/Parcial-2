import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pacial_2/helpers/session.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/providers/language_provider.dart';
import 'package:pacial_2/providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = ref.watch(profileProvider).requireValue;
    final isDark = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MaxWidth(
          width: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(child: UserAvatar(user: user, radius: 52)),
              const SizedBox(height: 16),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Center(
                child: Chip(
                  avatar: Icon(
                    user.isAdmin
                        ? Icons.admin_panel_settings_outlined
                        : Icons.person_outline,
                    size: 18,
                  ),
                  label: Text(user.isAdmin ? t.roleAdmin : t.roleCustomer),
                ),
              ),
              SectionTitle(t.settings),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: Text(t.darkMode),
                      value: isDark,
                      onChanged: (_) =>
                          ref.read(themeProvider.notifier).toggleTheme(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.translate),
                      title: Text(t.language),
                      trailing: SegmentedButton<String>(
                        showSelectedIcon: false,
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                        segments: const [
                          ButtonSegment(value: 'es', label: Text('ES')),
                          ButtonSegment(value: 'en', label: Text('EN')),
                        ],
                        selected: {locale.languageCode},
                        onSelectionChanged: (value) => ref
                            .read(languageProvider.notifier)
                            .changeLanguage(value.first),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.error,
                  side: BorderSide(color: scheme.error),
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () => logout(context, ref),
                icon: const Icon(Icons.logout),
                label: Text(t.logout),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
