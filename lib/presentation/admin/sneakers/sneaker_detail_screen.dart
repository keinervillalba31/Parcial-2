import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/config/theme/app_theme.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/helpers/format.dart';
import 'package:pacial_2/helpers/labels.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/model/sneaker/sneaker_model.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/cart_provider.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/services/sneakers/sneaker_service.dart';

class SneakerDetailScreen extends ConsumerWidget {
  final int id;

  const SneakerDetailScreen({super.key, required this.id});

  Future<void> _delete(BuildContext context, WidgetRef ref, Sneaker s) async {
    final t = AppLocalizations.of(context);
    final confirmed = await confirmDialog(
      context,
      title: t.deleteSneaker,
      message: t.deleteSneakerConfirm(s.name),
      confirmLabel: t.delete,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await SneakerService.delete(s.id);
      invalidateSneakerLists(ref);
      if (!context.mounted) return;
      showSnack(context, t.sneakerDeleted);
      context.pop();
    } catch (e) {
      // Ej: 409 si el tenis ya tiene pedidos.
      if (context.mounted) {
        showSnack(context, apiErrorMessage(e, t), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final sneaker = ref.watch(sneakerProvider(id));
    final isAdmin = ref.watch(profileProvider).value?.isAdmin ?? false;
    final loaded = sneaker.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(loaded?.name ?? t.sneaker),
        actions: [
          if (isAdmin && loaded != null) ...[
            IconButton(
              tooltip: t.edit,
              onPressed: () => context.push('/admin/sneakers/$id/edit'),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: t.delete,
              onPressed: () => _delete(context, ref, loaded),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ],
      ),
      body: AsyncView(
        value: sneaker,
        onRetry: () => ref.invalidate(sneakerProvider(id)),
        builder: (s) => _DetailBody(sneaker: s, isAdmin: isAdmin),
      ),
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  final Sneaker sneaker;
  final bool isAdmin;

  const _DetailBody({required this.sneaker, required this.isAdmin});

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  int? _size;
  int _quantity = 1;

  void _addToCart() {
    final t = AppLocalizations.of(context);
    final s = widget.sneaker;
    if (_size == null) {
      showSnack(context, t.chooseSize, isError: true);
      return;
    }

    final added = ref.read(cartProvider.notifier).add(s, _size!, _quantity);
    if (!added) {
      showSnack(context, t.notEnoughStock(s.stock), isError: true);
      return;
    }
    setState(() => _quantity = 1);
    showSnack(
      context,
      t.addedToCart,
      action: SnackBarAction(
        label: t.viewCart,
        onPressed: () => context.go('/admin/cart'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final gallery = _Gallery(
      images: widget.sneaker.images,
      label: widget.sneaker.brand.name,
    );
    final info = _info(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: MaxWidth(
        width: 1100,
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: gallery),
                  const SizedBox(width: 32),
                  Expanded(child: info),
                ],
              )
            : Column(children: [gallery, const SizedBox(height: 20), info]),
      ),
    );
  }

  Widget _info(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = widget.sneaker;
    ref.watch(cartProvider);
    final inCart = ref.read(cartProvider.notifier).quantityOf(s.id);
    final available = s.stock - inCart;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${s.brand.name} · ${s.category.name}'.toUpperCase(),
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(s.name, style: AppTheme.display(38, color: scheme.onSurface)),
        const SizedBox(height: 8),
        Text(
          formatPrice(s.price),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.accent,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.wc, size: 18),
              label: Text(genderLabel(t, s.gender)),
            ),
            Chip(
              avatar: Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: s.isOutOfStock ? scheme.error : null,
              ),
              label: Text(s.isOutOfStock ? t.outOfStock : t.inStock(s.stock)),
            ),
            if ((s.colors ?? '').isNotEmpty)
              Chip(
                avatar: const Icon(Icons.palette_outlined, size: 18),
                label: Text(s.colors!),
              ),
          ],
        ),
        if ((s.description ?? '').isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(s.description!, style: theme.textTheme.bodyLarge),
        ],
        SectionTitle(t.sizes),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final size in s.sizes)
              widget.isAdmin
                  ? Chip(label: Text('$size'))
                  : ChoiceChip(
                      label: Text('$size'),
                      selected: _size == size,
                      onSelected: s.isOutOfStock
                          ? null
                          : (selected) =>
                                setState(() => _size = selected ? size : null),
                    ),
          ],
        ),
        if (!widget.isAdmin) ...[
          const SizedBox(height: 20),
          if (available > 0)
            Row(
              children: [
                Text(t.quantity, style: theme.textTheme.titleSmall),
                const SizedBox(width: 12),
                QuantityStepper(
                  value: _quantity.clamp(1, available),
                  max: available,
                  onChanged: (value) => setState(() => _quantity = value),
                ),
              ],
            ),
          if (inCart > 0) ...[
            const SizedBox(height: 8),
            Text(
              t.alreadyInCart(inCart),
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: available > 0 ? _addToCart : null,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(
              (s.isOutOfStock ? t.outOfStock : t.addToCart).toUpperCase(),
            ),
          ),
        ],
      ],
    );
  }
}

class _Gallery extends StatefulWidget {
  final List<String> images;
  final String label;

  const _Gallery({required this.images, required this.label});

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final images = widget.images.isEmpty ? const <String>[''] : widget.images;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (_, index) =>
                  SneakerImage(url: images[index], label: widget.label),
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < images.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _page ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page ? AppTheme.accent : scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
