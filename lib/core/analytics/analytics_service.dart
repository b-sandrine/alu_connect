import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logSignUp(String role) =>
      _analytics.logSignUp(signUpMethod: role);

  Future<void> logLogin() => _analytics.logLogin(loginMethod: 'email');

  Future<void> logApply(String opportunityId) => _analytics.logEvent(
        name: 'apply_to_opportunity',
        parameters: {'opportunity_id': opportunityId},
      );

  Future<void> logBookmarkToggle({
    required String opportunityId,
    required bool added,
  }) =>
      _analytics.logEvent(
        name: added ? 'bookmark_opportunity' : 'unbookmark_opportunity',
        parameters: {'opportunity_id': opportunityId},
      );
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(FirebaseAnalytics.instance);
});
