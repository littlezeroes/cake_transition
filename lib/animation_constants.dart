import 'package:flutter/animation.dart';
import 'dart:io' show Platform;

/// Android Material Design 3 animation constants optimized for mobile devices
class AnimationConstants {
  // ========== ANDROID MATERIAL DESIGN 3 CURVES ==========
  // Official Material Design motion tokens
  
  /// Emphasized: For prominent motions (page transitions, major state changes)
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  
  /// Emphasized Decelerate: For elements entering the screen
  static const Curve emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1.0);
  
  /// Emphasized Accelerate: For elements exiting the screen  
  static const Curve emphasizedAccelerate = Cubic(0.3, 0.0, 0.8, 0.15);
  
  /// Standard: For standard motions (utility animations)
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);
  
  /// Standard Decelerate: For subtle entrances (fade in, scale in)
  static const Curve standardDecelerate = Cubic(0.0, 0.0, 0.0, 1.0);
  
  /// Standard Accelerate: For subtle exits (fade out)
  static const Curve standardAccelerate = Cubic(0.3, 0.0, 1.0, 1.0);
  
  // ========== ANDROID MOBILE OPTIMIZED DURATIONS ==========
  // Optimized for thumb zone interactions and 60fps performance
  
  /// Thumb Zone: Bottom navigation, FAB (fastest response)
  static const Duration thumbZone = Duration(milliseconds: 200);
  
  /// Reach Zone: Middle content, standard interactions  
  static const Duration reachZone = Duration(milliseconds: 250);
  
  /// Content Transitions: Page changes, major state transitions
  static const Duration contentTransition = Duration(milliseconds: 300);
  
  /// Surface Changes: Sheets, dialogs, overlays
  static const Duration surfaceChange = Duration(milliseconds: 250);
  
  /// Micro Interactions: Buttons, toggles, ripples
  static const Duration microInteraction = Duration(milliseconds: 150);
  
  // ========== COMPONENT MAPPINGS ==========
  // Standardized curve + duration per component type
  
  /// Page transitions: ease-out for responsive navigation
  static const ComponentAnimation pageAnimation = ComponentAnimation(
    duration: contentTransition,
    curve: standardDecelerate,
    reverseCurve: standardAccelerate,
  );
  
  /// Modal dialogs: quick ease-out for immediate response
  static const ComponentAnimation dialogAnimation = ComponentAnimation(
    duration: surfaceChange,
    curve: standardDecelerate,
    reverseCurve: standardAccelerate,
  );
  
  /// Bottom sheets: ease-out for sheet presentation
  static const ComponentAnimation bottomSheetAnimation = ComponentAnimation(
    duration: surfaceChange,
    curve: emphasizedDecelerate,
    reverseCurve: emphasizedAccelerate,
  );
  
  /// Drawer: ease-in-out for sliding repositioning
  static const ComponentAnimation drawerAnimation = ComponentAnimation(
    duration: reachZone,
    curve: standard,
    reverseCurve: standardAccelerate,
  );
  
  /// Navbar indicators: gentle for subtle state changes
  static const ComponentAnimation navbarAnimation = ComponentAnimation(
    duration: Duration(milliseconds: 250),
    curve: standard,
    reverseCurve: standard,
  );
}

/// Animation configuration container
class ComponentAnimation {
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  
  const ComponentAnimation({
    required this.duration,
    required this.curve,
    required this.reverseCurve,
  });
}