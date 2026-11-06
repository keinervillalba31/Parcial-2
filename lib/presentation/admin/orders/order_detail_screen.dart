import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/helpers/format.dart';
import 'package:pacial_2/helpers/labels.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/model/order/order_model.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/services/orders/order_service.dart';

class OrderDetailScreen extends ConsumerWidget {
  final int id;

  const OrderDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final isAdmin = ref.watch(profileProvider).value?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(t.orderNumber(id))),
      body: AsyncView(
        value: ref.watch(orderProvider(id)),
        onRetry: () => ref.invalidate(orderProvider(id)),
        builder: (order) => _OrderBody(order: order, isAdmin: isAdmin),
      ),
    );
  }
}

class _OrderBody extends ConsumerStatefulWidget {
  final Order order;
  final bool isAdmin;

  const _OrderBody({required this.order, required this.isAdmin});

  @override
  ConsumerState<_OrderBody> createState() => _OrderBodyState();
}

class _OrderBodyState extends ConsumerState<_OrderBody> {
  bool _updating = false;

  Future<void> _changeStatus(String status) async {
    final t = AppLocalizations.of(context);
    final order = widget.order;
    if (status == order.status) return;

    if (status == cancelledStatus) {
      final confirmed = await confirmDialog(
        context,
        title: t.cancelOrder,
        message: t.cancelOrderConfirm,
        confirmLabel: t.cancelOrder,
        destructive: true,
      );
      if (!confirmed || !mounted) return;
    }

    setState(() => _updating = true);
    try {
      await OrderService.updateStatus(order.id, status);
      ref.invalidate(orderProvider(order.id));
      ref.invalidate(ordersProvider);
      // Cancelar devuelve el stock, así que el catálogo cambia.
      invalidateSneakerLists(ref);
      ref.invalidate(sneakerProvider);
      if (mounted) showSnack(context, t.statusUpdated(statusLabel(t, status)));
    } catch (e) {
      if (mounted) showSnack(context, apiErrorMessage(e, t), isError: true);
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final order = widget.order;
    final isCancelled = order.status == cancelledStatus;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MaxWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatDate(order.createdAt),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          StatusChip(status: order.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _StatusTimeline(status: order.status),
                      if (widget.isAdmin) ...[
                        const Divider(height: 32),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: UserAvatar(user: order.user),
                          title: Text(order.user.name),
                          subtitle: Text(order.user.email),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SectionTitle(t.products),
              Card(
                child: Column(
                  children: [
                    for (final item in order.items)
                      ListTile(
                        onTap: () =>
                            context.push('/admin/sneakers/${item.sneakerId}'),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: SneakerImage(url: item.image),
                          ),
                        ),
                        title: Text(item.sneakerName),
                        subtitle: Text(
                          '${t.size} ${item.size} · ${item.quantity} × ${formatPrice(item.unitPrice)}',
                        ),
                        trailing: Text(
                          formatPrice(item.subtotal),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(
                        t.total,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        formatPrice(order.total),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isAdmin) ...[
                SectionTitle(t.changeStatus),
                if (isCancelled)
                  Text(
                    t.orderCancelledInfo,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final status in orderStatuses)
                        ChoiceChip(
                          avatar: Icon(statusIcon(status), size: 18),
                          label: Text(statusLabel(t, status)),
                          selected: order.status == status,
                          onSelected: _updating
                              ? null
                              : (_) => _changeStatus(status),
                        ),
                    ],
                  ),
                if (_updating) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

/// Progreso del pedido: pendiente → pagado → enviado → entregado.
class _StatusTimeline extends StatelessWidget {
  final String status;

  const _StatusTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    if (status == cancelledStatus) {
      return Row(
        children: [
          Icon(Icons.cancel, color: scheme.error),
          const SizedBox(width: 8),
          Expanded(child: Text(t.orderCancelledNotice)),
        ],
      );
    }

    final steps = orderStatuses.where((s) => s != cancelledStatus).toList();
    final current = steps.indexOf(status);

    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: i <= current
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                  child: Icon(
                    i < current ? Icons.check : statusIcon(steps[i]),
                    size: 18,
                    color: i <= current ? scheme.onPrimary : scheme.outline,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusLabel(t, steps[i]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: i == current ? FontWeight.bold : null,
                    color: i <= current ? null : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
