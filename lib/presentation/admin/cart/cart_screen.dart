import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/helpers/format.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/cart_provider.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/services/orders/order_service.dart';

/// Carrito del cliente. "Finalizar compra" crea el pedido en la API,
/// que valida tallas y stock y lo descuenta.
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _sending = false;

  Future<void> _checkout() async {
    final t = AppLocalizations.of(context);
    setState(() => _sending = true);
    try {
      final order = await OrderService.create(ref.read(cartProvider));
      ref.read(cartProvider.notifier).clear();
      ref.invalidate(ordersProvider);
      invalidateSneakerLists(ref);
      ref.invalidate(sneakerProvider);
      if (!mounted) return;
      showSnack(context, t.orderCreated);
      context.go('/admin/orders/${order.id}');
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      showSnack(context, apiErrorMessage(e, t), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final items = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);

    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.shopping_cart_outlined,
        message: t.cartEmpty,
        action: FilledButton.icon(
          style: compactButton,
          onPressed: () => context.go('/admin/sneakers'),
          icon: const Icon(Icons.storefront),
          label: Text(t.goToCatalog),
        ),
      );
    }

    final list = ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: SneakerImage(
                      url: item.sneaker.mainImage,
                      label: item.sneaker.brand.name,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.sneaker.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${t.size} ${item.size} · ${formatPrice(item.sneaker.price)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          QuantityStepper(
                            value: item.quantity,
                            max: cart.maxQuantityFor(item),
                            onChanged: (value) => cart.setQuantity(item, value),
                          ),
                          const Spacer(),
                          Text(
                            formatPrice(item.subtotal),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: t.delete,
                  onPressed: () => cart.remove(item),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        );
      },
    );

    final summary = Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(t.products)),
                Text(t.unitCount(cart.unitCount)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.total,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  formatPrice(cart.total),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _sending ? null : _checkout,
              icon: _sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(t.checkout),
            ),
          ],
        ),
      ),
    );

    if (MediaQuery.sizeOf(context).width >= 900) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: list),
          SizedBox(width: 360, child: summary),
        ],
      );
    }
    return Column(
      children: [
        Expanded(child: list),
        summary,
      ],
    );
  }
}
