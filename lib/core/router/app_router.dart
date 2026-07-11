import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'page_transitions.dart';
import '../analytics/analytics_service.dart';
import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/role_selection_screen.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/authentication/presentation/screens/startup_onboarding_screen.dart';
import '../../features/authentication/presentation/screens/student_onboarding_screen.dart';
import '../../features/applications/presentation/screens/applicants_screen.dart';
import '../../features/applications/presentation/screens/application_detail_screen.dart';
import '../../features/applications/presentation/screens/apply_screen.dart';
import '../../features/applications/presentation/screens/my_applications_screen.dart';
import '../../features/analytics/presentation/screens/startup_analytics_screen.dart';
import '../../features/bookmarks/presentation/providers/bookmark_providers.dart';
import '../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../features/dashboard/presentation/screens/startup_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/student_dashboard_screen.dart';
import '../../features/messaging/presentation/providers/presence_heartbeat_provider.dart';
import '../../features/messaging/presentation/screens/chat_screen.dart';
import '../../features/messaging/presentation/screens/conversations_screen.dart';
import '../../features/opportunities/domain/entities/opportunity_entity.dart';
import '../../features/opportunities/presentation/screens/create_edit_opportunity_screen.dart';
import '../../features/opportunities/presentation/screens/opportunity_detail_screen.dart';
import '../../features/profiles/presentation/screens/edit_startup_profile_screen.dart';
import '../../features/profiles/presentation/screens/edit_student_profile_screen.dart';
import '../../features/profiles/presentation/screens/manage_founders_screen.dart';
import '../../features/profiles/presentation/screens/manage_gallery_screen.dart';
import '../../features/profiles/presentation/screens/manage_team_screen.dart';
import '../../features/profiles/presentation/screens/startup_profile_screen.dart';
import '../widgets/error_view.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier();
  ref.listen(authStateProvider, (previous, next) {
    refreshNotifier.refresh();
  });
  ref.watch(presenceHeartbeatProvider);
  ref.watch(bookmarkMigrationProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    observers: [ref.watch(analyticsServiceProvider).observer],
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoading = authState.isLoading;
      if (isLoading) return '/';

      final user = authState.valueOrNull;
      final location = state.uri.toString();

      final publicRoutes = ['/login', '/register', '/role-selection'];
      final isPublic = publicRoutes.contains(location);

      if (user == null) {
        return isPublic ? null : '/login';
      }

      if (!user.hasCompletedOnboarding) {
        final onboardingRoute =
            user.isStudent ? '/student-onboarding' : '/startup-onboarding';
        if (location == onboardingRoute) return null;
        return onboardingRoute;
      }

      if (location == '/' || isPublic || location.contains('onboarding')) {
        return user.isStudent ? '/student-dashboard' : '/startup-dashboard';
      }

      final isEditOpportunity =
          location.startsWith('/opportunities/') && location.endsWith('/edit');
      final isApplicantsView =
          location.startsWith('/opportunities/') && location.endsWith('/applicants');
      final isApplyView =
          location.startsWith('/opportunities/') && location.endsWith('/apply');

      final startupOnly = location == '/startup-dashboard' ||
          location == '/opportunities/new' ||
          location == '/startup-profile/edit' ||
          location == '/startup-profile/founders' ||
          location == '/startup-profile/team' ||
          location == '/startup-profile/gallery' ||
          location == '/startup-analytics' ||
          isEditOpportunity ||
          isApplicantsView;

      final isApplicationDetail = location.startsWith('/applications/');

      final studentOnly = location == '/student-dashboard' ||
          location == '/my-applications' ||
          location == '/bookmarks' ||
          location == '/student-profile/edit' ||
          isApplyView ||
          isApplicationDetail;

      if (user.isStudent && startupOnly) return '/student-dashboard';
      if (user.isStartup && studentOnly) return '/startup-dashboard';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (_, state) =>
            fadeThroughPage(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (_, state) =>
            fadeThroughPage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: '/role-selection',
        pageBuilder: (_, state) =>
            sharedAxisPage(state: state, child: const RoleSelectionScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) {
          final role = state.extra as UserRole? ?? UserRole.student;
          return sharedAxisPage(state: state, child: RegisterScreen(role: role));
        },
      ),
      GoRoute(
        path: '/student-onboarding',
        pageBuilder: (_, state) =>
            sharedAxisPage(state: state, child: const StudentOnboardingScreen()),
      ),
      GoRoute(
        path: '/startup-onboarding',
        pageBuilder: (_, state) =>
            sharedAxisPage(state: state, child: const StartupOnboardingScreen()),
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
        path: '/startup-profile/founders',
        builder: (_, __) => const ManageFoundersScreen(),
      ),
      GoRoute(
        path: '/startup-profile/team',
        builder: (_, __) => const ManageTeamScreen(),
      ),
      GoRoute(
        path: '/startup-profile/gallery',
        builder: (_, __) => const ManageGalleryScreen(),
      ),
      GoRoute(
        path: '/student-profile/edit',
        builder: (_, __) => const EditStudentProfileScreen(),
      ),
      GoRoute(
        path: '/startup-profile/:ownerId',
        builder: (_, state) =>
            StartupProfileScreen(ownerId: state.pathParameters['ownerId']!),
      ),
      GoRoute(
        path: '/startup-analytics',
        builder: (_, __) => const StartupAnalyticsScreen(),
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
      GoRoute(
        path: '/applications/:id',
        builder: (_, state) =>
            ApplicationDetailScreen(applicationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/messages',
        builder: (_, __) => const ConversationsScreen(),
      ),
      GoRoute(
        path: '/messages/:id',
        builder: (_, state) =>
            ChatScreen(conversationId: state.pathParameters['id']!),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: ErrorView(message: state.error?.message ?? 'Page not found'),
    ),
  );
});
