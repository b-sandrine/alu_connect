import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';

/// Self-managing: watch this provider once from the app root to keep it
/// alive. It listens to auth state internally and starts/stops its own
/// heartbeat timer — no external start()/stop() calls needed.
final presenceHeartbeatProvider = Provider<void>((ref) {
  Timer? timer;
  String? activeUserId;

  void tick() {
    final userId = activeUserId;
    if (userId == null) return;
    ref.read(authRepositoryProvider).updateLastActiveAt(userId);
  }

  ref.listen(authStateProvider, (previous, next) {
    final user = next.valueOrNull;
    if (user == null) {
      timer?.cancel();
      timer = null;
      activeUserId = null;
      return;
    }
    if (activeUserId == user.id) return;

    activeUserId = user.id;
    tick();
    timer?.cancel();
    timer = Timer.periodic(AppConstants.presenceHeartbeatInterval, (_) => tick());
  }, fireImmediately: true);

  final lifecycleListener = AppLifecycleListener(onResume: tick);

  ref.onDispose(() {
    timer?.cancel();
    lifecycleListener.dispose();
  });
});
