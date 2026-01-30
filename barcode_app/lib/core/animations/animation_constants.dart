/// Animation duration and curve constants for consistent motion throughout the app.
/// 
/// Following Material Design 3 motion principles:
/// - Fast: Micro-interactions (150-200ms)
/// - Normal: Standard transitions (300-400ms)  
/// - Slow: Emphasis and attention-grabbing (500-600ms)
library;

import 'package:flutter/animation.dart';

/// Standard animation durations used across the app
class AnimationDurations {
  /// Fast duration for micro-interactions like button presses (200ms)
  static const Duration fast = Duration(milliseconds: 200);
  
  /// Normal duration for standard transitions and animations (300ms)
  static const Duration normal = Duration(milliseconds: 300);
  
  /// Slow duration for emphasis and complex transitions (500ms)
  static const Duration slow = Duration(milliseconds: 500);
  
  /// Delay between staggered animations (100ms)
  static const Duration staggerDelay = Duration(milliseconds: 100);
  
  /// Short stagger delay for dense grids (50ms)
  static const Duration shortStagger = Duration(milliseconds: 50);
  
  /// Page transition duration (350ms)
  static const Duration pageTransition = Duration(milliseconds: 350);
}

/// Standard animation curves following Material Design 3
class AnimationCurves {
  /// Smooth ease in and out for general transitions
  static const Curve smooth = Curves.easeInOutCubic;
  
  /// Bounce effect for playful emphasis
  static const Curve bounce = Curves.elasticOut;
  
  /// Material Design standard curve
  static const Curve snap = Curves.fastOutSlowIn;
  
  /// Slight overshoot for delightful feedback
  static const Curve overshoot = Curves.easeOutBack;
  
  /// Fast out for dismissing elements
  static const Curve fastOut = Curves.easeOut;
  
  /// Slow in for entering elements
  static const Curve slowIn = Curves.easeIn;
}
