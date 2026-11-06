import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/public/auth/widgets/auth_background.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/services/auth/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final t = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      showSnack(context, t.completeFields);
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
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
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeading(title: t.welcome, subtitle: t.loginSubtitle),
                const SizedBox(height: 32),

                /// EMAIL
                TextFormField(
                  controller: _emailController,
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
                    if (!_emailRegex.hasMatch(v)) return t.emailInvalid;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _loading ? null : _login(),
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
                const SizedBox(height: 28),

                /// LOGIN BUTTON
                FilledButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(t.login.toUpperCase()),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.goNamed('register'),
                  child: Text(t.noAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
