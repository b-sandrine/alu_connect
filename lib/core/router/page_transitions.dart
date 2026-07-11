import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Simple cross-fade, used for the redirect-driven splash <-> login/dashboard
/// transitions where there's no obvious "forward/back" direction.
CustomTransitionPage<T> fadeThroughPage<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

/// Fade + slight rightward slide, used for user-initiated forward
/// navigation (login -> role-selection -> register -> onboarding).
CustomTransitionPage<T> sharedAxisPage<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}
