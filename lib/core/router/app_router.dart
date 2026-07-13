import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/providers/auth_provider.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/products/presentation/product_list_screen.dart';
import '../../features/products/presentation/product_detail_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/wishlist/presentation/wishlist_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/orders/presentation/order_history_screen.dart';
import '../../features/orders/presentation/order_tracking_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../widgets/main_shell.dart';

// Route names
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const explore = '/explore';
  static const cart = '/cart';
  static const wishlist = '/wishlist';
  static const profile = '/profile';
  static const productList = '/products';
  static const productDetail = '/products/:id';
  static const checkout = '/checkout';
  static const orderHistory = '/orders';
  static const orderTracking = '/orders/:id/track';
  static const notifications = '/notifications';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _AuthStateListenable(ref),
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;
      final isInitial = authState.status == AuthStatus.initial;
      final isLoading = authState.isLoading;
      final location = state.uri.toString();

      if (isInitial || isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final authRoutes = [AppRoutes.login, AppRoutes.signup];
      if (!isAuth && !authRoutes.contains(location) && location != AppRoutes.splash) {
        return AppRoutes.login;
      }
      if (isAuth && authRoutes.contains(location)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      // Auth
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupScreen()),

      // Main shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
          GoRoute(path: AppRoutes.explore, builder: (_, s) {
            final category = s.uri.queryParameters['category'] ?? '';
            return ProductListScreen(category: category);
          }),
          GoRoute(path: AppRoutes.cart, builder: (_, __) => const CartScreen()),
          GoRoute(path: AppRoutes.wishlist, builder: (_, __) => const WishlistScreen()),
          GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
        ],
      ),

      // Product Detail
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (_, state) => ProductDetailScreen(
          productId: state.pathParameters['id'] ?? '',
        ),
      ),

      // Checkout
      GoRoute(path: AppRoutes.checkout, builder: (_, __) => const CheckoutScreen()),

      // Orders
      GoRoute(path: AppRoutes.orderHistory, builder: (_, __) => const OrderHistoryScreen()),
      GoRoute(
        path: AppRoutes.orderTracking,
        builder: (_, state) => OrderTrackingScreen(
          orderId: state.pathParameters['id'] ?? '',
        ),
      ),

      // Notifications
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),
    ],
  );
});

// Listenable for GoRouter refresh
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}
