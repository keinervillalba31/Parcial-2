import 'package:flutter/material.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';

/// Diálogo para crear una marca (nombre + logo) o una categoría (solo nombre).
///
/// [onSubmit] llama a la API; si falla, el error se muestra en el diálogo
/// y este sigue abierto para corregir (ej: nombre repetido → 409).
class CatalogDialog extends StatefulWidget {
  final String title;
  final bool withLogo;
  final Future<void> Function(String name, String? logo) onSubmit;

  const CatalogDialog({
    super.key,
    required this.title,
    required this.onSubmit,
    this.withLogo = false,
  });

  @override
  State<CatalogDialog> createState() => _CatalogDialogState();
}

class _CatalogDialogState extends State<CatalogDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _logo = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _logo.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final t = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final logo = _logo.text.trim();
      await widget.onSubmit(_name.text.trim(), logo.isEmpty ? null : logo);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = apiErrorMessage(e, t);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: InputDecoration(labelText: t.name),
                onFieldSubmitted: (_) => widget.withLogo ? null : _submit(),
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? t.requiredField : null,
              ),
              if (widget.withLogo) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _logo,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: t.logoUrl,
                    helperText: t.optional,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: Text(t.cancel),
        ),
        FilledButton(
          style: compactButton,
          onPressed: _saving ? null : _submit,
          child: Text(t.save),
        ),
      ],
    );
  }
}
