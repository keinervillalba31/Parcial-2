import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/helpers/api_error.dart';
import 'package:pacial_2/helpers/session.dart';
import 'package:pacial_2/l10n/app_localizations.dart';
import 'package:pacial_2/model/user/user_model.dart';
import 'package:pacial_2/providers/cart_provider.dart';
import 'package:pacial_2/providers/data_providers.dart';
import 'package:pacial_2/providers/language_provider.dart';
import 'package:pacial_2/providers/theme_provider.dart';
import 'package:pacial_2/presentation/widgets/async_view.dart';
import 'package:pacial_2/presentation/widgets/common.dart';

class _Destination {
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _Destination(this.route, this.icon, this.selectedIcon, this.label);
}

/// El menú cambia según el rol: el ADMIN gestiona, el cliente compra.
List<_Destination> _destinations(AppLocalizations t, bool isAdmin) => [
  _Destination(
    '/admin/home',
    Icons.space_dashboard_outlined,
    Icons.space_dashboard,
    t.home,
  ),
  _Destination(
    '/admin/sneakers',
    Icons.storefront_outlined,
    Icons.storefront,
    isAdmin ? t.sneakers : t.catalog,
  ),
  if (isAdmin) ...[
    _Destination('/admin/brands', Icons.sell_outlined, Icons.sell, t.brands),
    _Destination(
      '/admin/categories',
      Icons.category_outlined,
      Icons.category,
      t.categories,
    ),
  ] else
    _Destination(
      '/admin/cart',
      Icons.shopping_cart_outlined,
      Icons.shopping_cart,
      t.cart,
    ),
  _Destination(
    '/admin/orders',
    Icons.receipt_long_outlined,
    Icons.receipt_long,
    isAdmin ? t.orders : t.myOrders,
  ),
  _Destination('/admin/profile', Icons.person_outline, Icons.person, t.profile),
];

class AdminLayout extends ConsumerWidget {
  final String location;
  final Widget child;

  const AdminLayout({super.key, required this.location, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);

    // Hasta no saber el rol no se puede armar el menú.
    return profile.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: ErrorView(
          message: apiErrorMessage(error, t),
          onRetry: () => ref.invalidate(profileProvider),
          extra: TextButton(
            onPressed: () => logout(context, ref),
            child: Text(t.logout),
          ),
        ),
      ),
      data: (user) => _Shell(user: user, location: location, child: child),
    );
  }
}

class _Shell extends ConsumerWidget {
  final UserModel user;
  final String location;
  final Widget child;

  const _Shell({
    required this.user,
    required this.location,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final destinations = _destinations(t, user.isAdmin);
    final found = destinations.indexWhere(
      (d) => location == d.route || location.startsWith('${d.route}/'),
    );
    final selected = found < 0 ? 0 : found;
    final width = MediaQuery.sizeOf(context).width;

    final appBar = AppBar(
      title: Text(destinations[selected].label),
      actions: [
        if (!user.isAdmin) const _CartButton(),
        const _LanguageButton(),
        const _ThemeButton(),
        const SizedBox(width: 4),
      ],
    );

    void goTo(int index) => context.go(destinations[index].route);

    // Pantalla ancha (web / tablet): menú fijo a la izquierda.
    if (width >= 900) {
      final extended = width >= 1200;
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              extended: extended,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              selectedIndex: selected,
              onDestinationSelected: goTo,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Column(
                  children: [
                    BrandLogo(size: extended ? 26 : 22, compact: !extended),
                    const SizedBox(height: 20),
                    UserAvatar(user: user, radius: extended ? 28 : 20),
                  ],
                ),
              ),
              trailingAtBottom: true,
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: IconButton(
                  tooltip: t.logout,
                  onPressed: () => logout(context, ref),
                  icon: const Icon(Icons.logout),
                ),
              ),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    // Celular: menú en un drawer.
    return Scaffold(
      appBar: appBar,
      drawer: NavigationDrawer(
        selectedIndex: selected,
        onDestinationSelected: (index) {
          Navigator.of(context).pop();
          goTo(index);
        },
        children: [
          _DrawerHeader(user: user),
          for (final d in destinations)
            NavigationDrawerDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: Text(d.label),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Text(t.logout),
              shape: const StadiumBorder(),
              onTap: () => logout(context, ref),
            ),
          ),
        ],
      ),
      body: child,
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final UserModel user;

  const _DrawerHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandLogo(size: 24),
          const SizedBox(height: 20),
          UserAvatar(user: user, radius: 30),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.isAdmin ? t.roleAdmin : t.roleCustomer,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartButton extends ConsumerWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    ref.watch(cartProvider);
    final count = ref.read(cartProvider.notifier).unitCount;

    return IconButton(
      tooltip: t.cart,
      onPressed: () => context.go('/admin/cart'),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}

class _LanguageButton extends ConsumerWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final code = ref.watch(languageProvider).languageCode;

    return IconButton(
      tooltip: t.language,
      onPressed: () => ref
          .read(languageProvider.notifier)
          .changeLanguage(code == 'es' ? 'en' : 'es'),
      icon: Text(
        code.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ThemeButton extends ConsumerWidget {
  const _ThemeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final isDark = ref.watch(themeProvider);

    return IconButton(
      tooltip: t.theme,
      onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
      icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
    );
  }
}
