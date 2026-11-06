import 'package:flutter/material.dart';
import 'package:pacial_2/l10n/app_localizations.dart';

/// El tema hace los FilledButton de ancho completo (formularios). Este estilo
/// es para botones dentro de filas o diálogos, donde ese ancho no cabe.
final ButtonStyle compactButton = FilledButton.styleFrom(
  minimumSize: const Size(88, 44),
);

void showSnack(
  BuildContext context,
  String message, {
  bool isError = false,
  SnackBarAction? action,
}) {
  final scheme = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? scheme.error : null,
        content: Text(message),
        action: action,
      ),
    );
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final t = AppLocalizations.of(context);
  final scheme = Theme.of(context).colorScheme;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(t.cancel),
        ),
        FilledButton(
          style: destructive
              ? compactButton.merge(
                  FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  ),
                )
              : compactButton,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
