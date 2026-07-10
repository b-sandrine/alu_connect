import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/role_selection_screen.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/authentication/presentation/screens/startup_onboarding_screen.dart';
import '../../features/authentication/presentation/screens/student_onboarding_screen.dart';
import '../../features/applications/presentation/screens/applicants_screen.dart';
import '../../features/applications/presentation/screens/apply_screen.dart';
import '../../features/applications/presentation/screens/my_applications_screen.dart';
import '../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../features/dashboard/presentation/screens/startup_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/student_dashboard_screen.dart';
import '../../features/opportunities/domain/entities/opportunity_entity.dart';
import '../../features/opportunities/presentation/screens/create_edit_opportunity_screen.dart';
import '../../features/opportunities/presentation/screens/opportunity_detail_screen.dart';
import '../../features/startup_profile/presentation/screens/edit_startup_profile_screen.dart';
import '../../features/startup_profile/presentation/screens/startup_profile_screen.dart';
import '../widgets/error_view.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshStream = GoRouterRefreshStream (
    ref.watch(authRepositoryProvider).authStateChanges,
  );
  ref.onDispose(() => refreshStream.dispose());

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
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
        builder: (_, __) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: '/startup-dashboard',
        builder: (_, __) => const StartupDashboardScreen(),
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (_, __) => const BookmarksScreen(),
      ),
      GoRoute(
        path: '/startup-profile/edit',
        builder: (_, __) => const EditStartupProfileScreen(),
      ),
      GoRoute(
        path: '/startup-profile/:ownerId',
        builder: (_, state) =>
            StartupProfileScreen(ownerId: state.pathParameters['ownerId']!),
      ),
      GoRoute(
        path: '/opportunities/new',
        builder: (_, __) => const CreateEditOpportunityScreen(),
      ),
      GoRoute(
        path: '/opportunities/:id/edit',
        builder: (_, state) => CreateEditOpportunityScreen(
          existing: state.extra as OpportunityEntity?,
        ),
      ),
      GoRoute(
        path: '/opportunities/:id',
        builder: (_, state) =>
            OpportunityDetailScreen(opportunityId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/opportunities/:id/apply',
        builder: (_, state) =>
            ApplyScreen(opportunityId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/opportunities/:id/applicants',
        builder: (_, state) =>
            ApplicantsScreen(opportunityId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/my-applications',
        builder: (_, __) => const MyApplicationsScreen(),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: ErrorView(message: state.error?.message ?? 'Page not found'),
    ),
  );
});
