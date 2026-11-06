import 'package:flutter/material.dart';
import 'package:pacial_2/config/theme/app_theme.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/public/auth/widgets/auth_top_bar.dart';
import 'package:pacial_2/presentation/widgets/common.dart';

/// Marco de login y registro: panel de marca a la izquierda y formulario a la
/// derecha. En celular el panel queda arriba, más pequeño.
class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final form = SafeArea(
      child: Column(
        children: [
          const AuthTopBar(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (wide) {
      return Row(
        children: [
          const Expanded(flex: 11, child: _Hero(big: true)),
          Expanded(flex: 9, child: form),
        ],
      );
    }

    // Celular: el panel arriba y el formulario debajo, todo con scroll.
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 250, child: _Hero(big: false)),
        const AuthTopBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: child,
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final bool big;

  const _Hero({required this.big});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    const muted = Color(0xFF8A8883);

    return ClipRect(
      child: ColoredBox(
        color: AppTheme.ink,
        child: Stack(
          children: [
            // Franjas diagonales de acento.
            Positioned(
              right: -120,
              bottom: big ? 80 : -40,
              child: Transform.rotate(
                angle: -0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _Stripe(width: big ? 520 : 320, height: big ? 34 : 20),
                    SizedBox(height: big ? 14 : 8),
                    _Stripe(
                      width: big ? 420 : 260,
                      height: big ? 34 : 20,
                      opacity: 0.5,
                    ),
                    SizedBox(height: big ? 14 : 8),
                    _Stripe(
                      width: big ? 320 : 200,
                      height: big ? 34 : 20,
                      opacity: 0.25,
                    ),
                  ],
                ),
              ),
            ),
            // Marca gigante de fondo.
            if (big)
              Positioned(
                left: -20,
                bottom: -40,
                child: Text(
                  'SNEAKHUB',
                  style: AppTheme.display(
                    180,
                    color: Colors.white.withValues(alpha: 0.04),
                  ).copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(big ? 48 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    bottom: false,
                    child: BrandLogo(size: big ? 28 : 22, color: Colors.white),
                  ),
                  const Spacer(),
                  Tag(t.heroTag),
                  SizedBox(height: big ? 20 : 12),
                  Text(
                    t.heroTitle,
                    style: AppTheme.display(big ? 76 : 38, color: Colors.white),
                  ),
                  if (big) ...[
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Text(
                        t.heroSubtitle,
                        style: const TextStyle(
                          color: Color(0xFFCFCDC7),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      t.heroBrands,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stripe extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;

  const _Stripe({required this.width, required this.height, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}

/// Título grande y subtítulo de los formularios de login y registro.
class AuthHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeading({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.display(34, color: scheme.onSurface)),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15),
        ),
      ],
    );
  }
}
