import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:pacial_2/presentation/admin/brands/brands_screen.dart';
import 'package:pacial_2/presentation/admin/cart/cart_screen.dart';
import 'package:pacial_2/presentation/admin/categories/categories_screen.dart';
import 'package:pacial_2/presentation/admin/home/home_screen.dart';
import 'package:pacial_2/presentation/admin/layout/admin_layout.dart';
import 'package:pacial_2/presentation/admin/orders/order_detail_screen.dart';
import 'package:pacial_2/presentation/admin/orders/orders_screen.dart';
import 'package:pacial_2/presentation/admin/profile/profile_screen.dart';
import 'package:pacial_2/presentation/admin/sneakers/sneaker_detail_screen.dart';
import 'package:pacial_2/presentation/admin/sneakers/sneaker_form_screen.dart';
import 'package:pacial_2/presentation/admin/sneakers/sneakers_screen.dart';
import 'package:pacial_2/presentation/public/auth/auth_screen.dart';
import 'package:pacial_2/presentation/public/register/register_screen.dart';
import 'package:pacial_2/services/auth/auth_service.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

const _publicRoutes = {'/', '/register'};

/// Rutas que solo puede abrir un ADMIN (la API igual respondería 403).
bool _isAdminOnly(String location) =>
    location.startsWith('/admin/brands') ||
    location.startsWith('/admin/categories') ||
    location == '/admin/sneakers/new' ||
    location.endsWith('/edit');

int _id(GoRouterState state) => int.tryParse(state.pathParameters['id']!) ?? 0;

/// Las pantallas del menú cambian sin animación (como pestañas).
Page<void> _tab(Widget child) => NoTransitionPage(child: child);

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) async {
    final location = state.matchedLocation;
    final role = await AuthService.currentRole();
    final isPublic = _publicRoutes.contains(location);

    if (role == null) return isPublic ? null : '/';
    if (isPublic) return '/admin/home';
    if (role != 'ADMIN' && _isAdminOnly(location)) return '/admin/home';
    if (role == 'ADMIN' && location == '/admin/cart') return '/admin/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Zona con sesión: el layout (menú + barra superior) envuelve cada pantalla.
    // Los detalles y formularios se abren encima, a pantalla completa.
    ShellRoute(
      builder: (context, state, child) =>
          AdminLayout(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: '/admin/home',
          name: 'home',
          pageBuilder: (context, state) => _tab(const HomeScreen()),
        ),
        GoRoute(
          path: '/admin/sneakers',
          name: 'sneakers',
          pageBuilder: (context, state) => _tab(const SneakersScreen()),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const SneakerFormScreen(),
            ),
            GoRoute(
              path: ':id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => SneakerDetailScreen(id: _id(state)),
              routes: [
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) =>
                      SneakerFormScreen(id: _id(state)),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/admin/brands',
          name: 'brands',
          pageBuilder: (context, state) => _tab(const BrandsScreen()),
        ),
        GoRoute(
          path: '/admin/categories',
          name: 'categories',
          pageBuilder: (context, state) => _tab(const CategoriesScreen()),
        ),
        GoRoute(
          path: '/admin/orders',
          name: 'orders',
          pageBuilder: (context, state) => _tab(const OrdersScreen()),
          routes: [
            GoRoute(
              path: ':id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => OrderDetailScreen(id: _id(state)),
            ),
          ],
        ),
        GoRoute(
          path: '/admin/cart',
          name: 'cart',
          pageBuilder: (context, state) => _tab(const CartScreen()),
        ),
        GoRoute(
          path: '/admin/profile',
          name: 'profile',
          pageBuilder: (context, state) => _tab(const ProfileScreen()),
        ),
      ],
    ),
  ],
);
