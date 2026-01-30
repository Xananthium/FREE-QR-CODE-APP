/// Custom page transitions for GoRouter navigation.
/// 
/// Provides Material Design 3 style transitions for smooth navigation.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'animation_constants.dart';

/// Creates a slide transition from right (for forward navigation).
Page<void> buildSlideTransitionPage({
  required Widget child,
  required GoRouterState state,
  Duration duration = AnimationDurations.pageTransition,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: AnimationCurves.smooth),
      );
      
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

/// Creates a fade transition (for modals and overlays).
Page<void> buildFadeTransitionPage({
  required Widget child,
  required GoRouterState state,
  Duration duration = AnimationDurations.normal,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(
          CurveTween(curve: AnimationCurves.smooth),
        ),
        child: child,
      );
    },
  );
}

/// Creates a slide + fade combination (premium feel).
Page<void> buildSlideFadeTransitionPage({
  required Widget child,
  required GoRouterState state,
  Duration duration = AnimationDurations.pageTransition,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.05, 0.0); // Slight slide from right
      const end = Offset.zero;
      
      final slideTween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: AnimationCurves.smooth),
      );
      
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: AnimationCurves.smooth),
      );
      
      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

/// Creates a scale transition (for bottom sheets, dialogs).
Page<void> buildScaleTransitionPage({
  required Widget child,
  required GoRouterState state,
  Duration duration = AnimationDurations.normal,
  Alignment alignment = Alignment.center,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scaleTween = Tween<double>(begin: 0.8, end: 1.0).chain(
        CurveTween(curve: AnimationCurves.overshoot),
      );
      
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: AnimationCurves.smooth),
      );
      
      return ScaleTransition(
        scale: animation.drive(scaleTween),
        alignment: alignment,
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
