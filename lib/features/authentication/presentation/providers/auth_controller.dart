import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_providers.dart';

class AuthController extends AsyncNotifier<void> {
  late AuthRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.watch(authRepositoryProvider);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final user = await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
      unawaited(_onAuthenticated(user, isSignUp: false));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await _repository.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
      state = const AsyncData(null);
      unawaited(_onAuthenticated(user, isSignUp: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.signOut());
  }

  Future<void> completeOnboarding(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.completeOnboarding(userId));
  }

  bool get isEmailVerified => _repository.isEmailVerified;

  Future<void> sendEmailVerification() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.sendEmailVerification());
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  Future<void> deleteAccount({required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.deleteAccount(password: password));
  }

  /// Requests notification permission and registers the device's FCM token.
  /// Called automatically after sign-in, and re-callable from Settings if
  /// the user turns push notifications back on.
  Future<void> registerPushNotifications(String userId) => _registerFcmToken(userId);

  Future<void> disablePushNotifications(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.clearFcmToken(userId));
  }

  String? getErrorMessage() {
    return state.whenOrNull(
      error: (e, _) => e is AppException ? e.message : 'Something went wrong.',
    );
  }

  Future<void> _onAuthenticated(UserEntity user, {required bool isSignUp}) async {
    final analytics = ref.read(analyticsServiceProvider);
    if (isSignUp) {
      await analytics.logSignUp(user.role.name);
    } else {
      await analytics.logLogin();
    }
    unawaited(_registerFcmToken(user.id));
  }

  Future<void> _registerFcmToken(String userId) async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;
      final token = await messaging.getToken();
      if (token != null) {
        await _repository.updateFcmToken(userId, token);
      }
    } catch (_) {
      // Notification setup is best-effort and must never block sign-in/registration.
    }
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);
