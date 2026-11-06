import 'package:flutter/material.dart';
import 'package:pacial_2/config/theme/app_theme.dart';
import 'package:pacial_2/helpers/labels.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/model/user/user_model.dart';

/// Imagen de red con fondo mientras carga. Si no hay imagen o falla, muestra
/// el texto de [label] (ej. la marca) en grande, al estilo de la tienda.
class SneakerImage extends StatelessWidget {
  final String? url;
  final String? label;
  final BoxFit fit;

  const SneakerImage({
    super.key,
    required this.url,
    this.label,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = (label ?? '').trim().toUpperCase();
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: text.isEmpty
          ? Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: scheme.outline,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: AppTheme.display(
                      40,
                      color: scheme.onSurface.withValues(alpha: 0.18),
                    ).copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
    );

    final src = url?.trim() ?? '';
    if (src.isEmpty) return placeholder;

    return Image.network(
      src,
      fit: fit,
      errorBuilder: (_, _, _) => placeholder,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon(status), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            statusLabel(AppLocalizations.of(context), status),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar con la foto del usuario o sus iniciales si no carga.
class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double radius;

  const UserAvatar({super.key, required this.user, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = user.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    final avatar = user.avatar ?? '';

    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      foregroundImage: avatar.isEmpty ? null : NetworkImage(avatar),
      onForegroundImageError: avatar.isEmpty ? null : (_, _) {},
      child: Text(
        initials,
        style: TextStyle(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}

class QuantityStepper extends StatelessWidget {
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          visualDensity: VisualDensity.compact,
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove, size: 18),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        IconButton.outlined(
          visualDensity: VisualDensity.compact,
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add, size: 18),
        ),
      ],
    );
  }
}

/// Título de sección dentro de una pantalla.
class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Limita el ancho del contenido en pantallas grandes.
class MaxWidth extends StatelessWidget {
  final double width;
  final Widget child;

  const MaxWidth({super.key, this.width = 760, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}

/// Logo de texto: "SNEAK" en el color del texto y "HUB" en el acento.
class BrandLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool compact;

  const BrandLogo({
    super.key,
    this.size = 22,
    this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final main = color ?? Theme.of(context).colorScheme.onSurface;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: compact ? 'S' : 'SNEAK'),
          TextSpan(
            text: compact ? 'H' : 'HUB',
            style: const TextStyle(color: AppTheme.accent),
          ),
        ],
      ),
      style: AppTheme.display(
        size,
        color: main,
      ).copyWith(fontStyle: FontStyle.italic, letterSpacing: -1),
    );
  }
}

/// Etiqueta corta en mayúsculas (ej. "NUEVA TEMPORADA").
class Tag extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;

  const Tag(
    this.text, {
    super.key,
    this.background = AppTheme.accent,
    this.foreground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
