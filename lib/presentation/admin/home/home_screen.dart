import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/config/theme/app_theme.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/helpers/format.dart';
import 'package:pacial_2/helpers/labels.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/model/order/order_model.dart';
import 'package:pacial_2/model/sneaker/sneaker_model.dart';
import 'package:pacial_2/model/user/user_model.dart';
import 'package:pacial_2/presentation/admin/sneakers/widgets/sneaker_card.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/common.dart';
import 'package:pacial_2/presentation/widgets/feedback.dart';
import 'package:pacial_2/providers/cart_provider.dart';
import 'package:pacial_2/providers/data_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final user = ref.watch(profileProvider).requireValue;
    final sneakers = ref.watch(allSneakersProvider);
    final orders = ref.watch(ordersProvider);

    void reload() {
      ref.invalidate(allSneakersProvider);
      ref.invalidate(ordersProvider);
    }

    final error = sneakers.error ?? orders.error;
    if (error != null) {
      return ErrorView(message: apiErrorMessage(error, t), onRetry: reload);
    }
    if (!sneakers.hasValue || !orders.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        reload();
        await ref.read(ordersProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MaxWidth(
            width: 1100,
            child: user.isAdmin
                ? _AdminDashboard(
                    user: user,
                    sneakers: sneakers.requireValue,
                    orders: orders.requireValue,
                  )
                : _CustomerHome(
                    user: user,
                    sneakers: sneakers.requireValue,
                    orders: orders.requireValue,
                  ),
          ),
        ],
      ),
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  final UserModel user;
  final List<Sneaker> sneakers;
  final List<Order> orders;

  const _AdminDashboard({
    required this.user,
    required this.sneakers,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final active = orders.where((o) => o.status != cancelledStatus);
    final revenue = active.fold<double>(0, (sum, o) => sum + o.total);
    final pending = orders.where((o) => o.status == 'PENDIENTE').length;
    final lowStock = sneakers.where((s) => s.stock <= 5).toList()
      ..sort((a, b) => a.stock.compareTo(b.stock));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Greeting(
          name: user.name,
          tag: t.adminTag,
          subtitle: t.dashboardSubtitle,
        ),
        const SizedBox(height: 16),
        _StatGrid(
          stats: [
            _Stat(
              Icons.storefront,
              t.sneakers,
              '${sneakers.length}',
              scheme.onSurface,
            ),
            _Stat(
              Icons.inventory_2_outlined,
              t.lowStock,
              '${lowStock.length}',
              AppTheme.accent,
            ),
            _Stat(
              Icons.schedule,
              t.pendingOrders,
              '$pending',
              scheme.onSurface,
            ),
            _Stat(
              Icons.payments_outlined,
              t.sales,
              formatPrice(revenue),
              scheme.onSurface,
            ),
          ],
        ),
        SectionTitle(
          t.recentOrders,
          trailing: TextButton(
            onPressed: () => context.go('/admin/orders'),
            child: Text(t.seeAll),
          ),
        ),
        Card(
          child: orders.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(t.noOrders, textAlign: TextAlign.center),
                )
              : Column(
                  children: [
                    for (final order in orders.take(5))
                      ListTile(
                        onTap: () => context.push('/admin/orders/${order.id}'),
                        leading: UserAvatar(user: order.user),
                        title: Text(t.orderNumber(order.id)),
                        subtitle: Text(
                          '${order.user.name} · ${formatDate(order.createdAt)}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatPrice(order.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            StatusChip(status: order.status),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        SectionTitle(t.lowStockTitle),
        Card(
          child: lowStock.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(t.stockOk, textAlign: TextAlign.center),
                )
              : Column(
                  children: [
                    for (final s in lowStock)
                      ListTile(
                        onTap: () => context.push('/admin/sneakers/${s.id}'),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: SneakerImage(
                              url: s.mainImage,
                              label: s.brand.name,
                            ),
                          ),
                        ),
                        title: Text(s.name),
                        subtitle: Text(s.brand.name),
                        trailing: Text(
                          s.isOutOfStock ? t.outOfStock : t.unitsLeft(s.stock),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: s.isOutOfStock
                                ? Theme.of(context).colorScheme.error
                                : AppTheme.accent,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _CustomerHome extends ConsumerWidget {
  final UserModel user;
  final List<Sneaker> sneakers;
  final List<Order> orders;

  const _CustomerHome({
    required this.user,
    required this.sneakers,
    required this.orders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    ref.watch(cartProvider);
    final inCart = ref.read(cartProvider.notifier).unitCount;
    final latest = sneakers.reversed
        .where((s) => !s.isOutOfStock)
        .take(8)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Greeting(
          name: user.name,
          tag: t.heroTag,
          subtitle: t.customerSubtitle,
          action: FilledButton.icon(
            style: compactButton.merge(
              FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
              ),
            ),
            onPressed: () => context.go('/admin/sneakers'),
            icon: const Icon(Icons.storefront),
            label: Text(t.goToCatalog.toUpperCase()),
          ),
        ),
        const SizedBox(height: 16),
        _StatGrid(
          stats: [
            _Stat(
              Icons.receipt_long,
              t.myOrders,
              '${orders.length}',
              scheme.onSurface,
            ),
            _Stat(
              Icons.shopping_cart_outlined,
              t.cart,
              '$inCart',
              AppTheme.accent,
            ),
          ],
        ),
        SectionTitle(
          t.newArrivals,
          trailing: TextButton(
            onPressed: () => context.go('/admin/sneakers'),
            child: Text(t.seeAll),
          ),
        ),
        SizedBox(
          height: 310,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: latest.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 220,
              child: SneakerCard(
                sneaker: latest[index],
                onTap: () =>
                    context.push('/admin/sneakers/${latest[index].id}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  final String name;
  final String tag;
  final String subtitle;
  final Widget? action;

  const _Greeting({
    required this.name,
    required this.tag,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 700;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ColoredBox(
        color: AppTheme.ink,
        child: Stack(
          children: [
            Positioned(
              right: -60,
              top: 0,
              bottom: 0,
              child: Transform.rotate(
                angle: -0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final (width, alpha) in [
                      (260.0, 1.0),
                      (210.0, 0.5),
                      (160.0, 0.25),
                    ])
                      Container(
                        width: wide ? width * 1.4 : width,
                        height: wide ? 26 : 18,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: alpha),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(wide ? 36 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tag(tag),
                  const SizedBox(height: 16),
                  Text(
                    t.hello(name.split(' ').first).toUpperCase(),
                    style: AppTheme.display(
                      wide ? 48 : 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFCFCDC7),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (action != null) ...[const SizedBox(height: 20), action!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Stat(this.icon, this.label, this.value, this.color);
}

class _StatGrid extends StatelessWidget {
  final List<_Stat> stats;

  const _StatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final columns = constraints.maxWidth >= 800 ? 4 : 2;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final stat in stats)
              SizedBox(
                width: width,
                child: _StatCard(stat: stat),
              ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final _Stat stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    stat.label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Icon(stat.icon, size: 20, color: stat.color),
              ],
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                stat.value,
                style: AppTheme.display(30, color: scheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
