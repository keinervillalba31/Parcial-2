import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/format.dart';
import 'package:pacial_2/helpers/labels.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/model/order/order_model.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/data_providers.dart';

/// ADMIN: todos los pedidos. Cliente: solo los suyos (lo filtra la API).
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String? _status;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final orders = ref.watch(ordersProvider);
    final isAdmin = ref.watch(profileProvider).value?.isAdmin ?? false;

    return Column(
      children: [
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(t.all),
                  selected: _status == null,
                  onSelected: (_) => setState(() => _status = null),
                ),
              ),
              for (final status in orderStatuses)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(statusIcon(status), size: 18),
                    label: Text(statusLabel(t, status)),
                    selected: _status == status,
                    onSelected: (selected) =>
                        setState(() => _status = selected ? status : null),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: AsyncView(
            value: orders,
            onRetry: () => ref.invalidate(ordersProvider),
            builder: (list) {
              final filtered = _status == null
                  ? list
                  : list.where((o) => o.status == _status).toList();

              if (filtered.isEmpty) {
                return EmptyState(
                  icon: Icons.receipt_long_outlined,
                  message: list.isEmpty && !isAdmin
                      ? t.noOrdersCustomer
                      : t.noOrders,
                  action: list.isEmpty && !isAdmin
                      ? FilledButton(
                          style: compactButton,
                          onPressed: () => context.go('/admin/sneakers'),
                          child: Text(t.goToCatalog),
                        )
                      : null,
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.refresh(ordersProvider.future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => MaxWidth(
                    child: _OrderCard(order: filtered[index], isAdmin: isAdmin),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final bool isAdmin;

  const _OrderCard({required this.order, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final subtitle = [
      if (isAdmin) order.user.name,
      formatDate(order.createdAt),
      t.unitCount(order.unitCount),
    ].join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/admin/orders/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              isAdmin
                  ? UserAvatar(user: order.user, radius: 22)
                  : CircleAvatar(
                      radius: 22,
                      child: Icon(statusIcon(order.status)),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.orderNumber(order.id),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatPrice(order.total),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  StatusChip(status: order.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
