import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/public/auth/widgets/auth_background.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/services/auth/auth_service.dart';

/// Registro de clientes (la API siempre crea la cuenta con rol CUSTOMER).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    final t = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      showSnack(context, t.completeFields);
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) context.goNamed('home');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showSnack(context, apiErrorMessage(e, t), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeading(title: t.createAccount, subtitle: t.registerSubtitle),
              const SizedBox(height: 32),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                decoration: InputDecoration(
                  labelText: t.name,
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? t.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: t.email,
                  prefixIcon: const Icon(Icons.alternate_email),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return t.emailRequired;
                  if (!_emailRegex.hasMatch(v)) {
                    return t.emailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                decoration: InputDecoration(
                  labelText: t.password,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.passwordRequired;
                  }
                  if (value.length < 4) return t.passwordMin;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirm,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _loading ? null : _register(),
                decoration: InputDecoration(
                  labelText: t.confirmPassword,
                  prefixIcon: const Icon(Icons.lock_reset),
                ),
                validator: (value) =>
                    value != _password.text ? t.passwordsDontMatch : null,
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      )
                    : Text(t.register.toUpperCase()),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.goNamed('login'),
                child: Text(t.haveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
