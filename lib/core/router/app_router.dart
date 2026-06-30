import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/role_selection_screen.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/authentication/presentation/screens/startup_onboarding_screen.dart';
import '../../features/authentication/presentation/screens/student_onboarding_screen.dart';
import '../../features/startup_profile/presentation/screens/edit_startup_profile_screen.dart';
import '../../features/startup_profile/presentation/screens/startup_profile_screen.dart';
import '../widgets/error_view.dart';

// Placeholder screens used until the full features are implemented
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)));
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      if (isLoading) return '/';

      final user = authState.valueOrNull;
      final location = state.uri.toString();

      final publicRoutes = ['/', '/login', '/register', '/role-selection'];
      final isPublic = publicRoutes.any((r) => location.startsWith(r));

      if (user == null) {
        return isPublic ? null : '/login';
      }

      if (!user.hasCompletedOnboarding) {
        final onboardingRoute =
            user.isStudent ? '/student-onboarding' : '/startup-onboarding';
        if (location == onboardingRoute) return null;
        return onboardingRoute;
      }

      if (isPublic || location.contains('onboarding')) {
        return user.isStudent ? '/student-dashboard' : '/startup-dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (_, __) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final role = state.extra as UserRole? ?? UserRole.student;
          return RegisterScreen(role: role);
        },
      ),
      GoRoute(
        path: '/student-onboarding',
        builder: (_, __) => const StudentOnboardingScreen(),
      ),
      GoRoute(
        path: '/startup-onboarding',
        builder: (_, __) => const StartupOnboardingScreen(),
      ),
      GoRoute(
        path: '/student-dashboard',
        builder: (_, __) => const _PlaceholderScreen(title: 'Student Dashboard'),
      ),
      GoRoute(
        path: '/startup-dashboard',
        builder: (_, __) => const _PlaceholderScreen(title: 'Startup Dashboard'),
      ),
      GoRoute(
        path: '/startup-profile/:ownerId',
        builder: (_, state) =>
            StartupProfileScreen(ownerId: state.pathParameters['ownerId']!),
      ),
      GoRoute(
        path: '/startup-profile/edit',
        builder: (_, __) => const EditStartupProfileScreen(),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: ErrorView(message: state.error?.message ?? 'Page not found'),
    ),
  );
});
