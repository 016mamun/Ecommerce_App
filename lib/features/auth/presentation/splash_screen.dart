import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../domain/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme_colors.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(AppRoutes.home);
      } else if (next.status == AuthStatus.unauthenticated ||
          next.status == AuthStatus.error) {
        context.go(AppRoutes.login);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.status == AuthStatus.authenticated) {
        context.go(AppRoutes.home);
      } else if (authState.status == AuthStatus.unauthenticated ||
          authState.status == AuthStatus.error) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      backgroundColor: context.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: context.textPrimaryColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.tagline,
              style: TextStyle(
                fontSize: 14,
                color: context.textSecondaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 60),
            if (authState.isLoading || authState.status == AuthStatus.initial)
              const SpinKitThreeBounce(
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
