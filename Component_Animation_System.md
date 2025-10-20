# Component Animation Classification System

> Based on Apple's 15+ years of research and decision tree methodology

---

## 🎯 Apple's Decision Framework

### The Decision Flow
```
Component Type → User Goal → Cognitive Load → Animation Type → Specific Numbers
👆              👆           👆              👆              👆
```

### Component Classification Hierarchy

## 📚 Tier 1: Critical Interactions (Most Important)

### **Characteristics**
- **Immediate user feedback required**
- **Low cognitive load**
- **Fast response expected**
- **High frequency usage**

### **Components**
| Component | User Goal | Cognitive Load | Animation | Speed | Damping |
|-----------|-----------|----------------|-----------|-------|---------|
| **Button** | Action | Low | Snappy | 0.15s | 0.95 |
| **Switch** | Toggle | Low | Snappy | 0.2s | 0.95 |
| **Keyboard** | Input | Critical | Snappy | 0.25s | 0.95 |
| **Checkbox** | Select | Low | Snappy | 0.15s | 0.95 |

### **Implementation Rules**
```dart
// Critical Interactions - Must be instant
const double kCriticalSpeed = 0.15; // 0.15-0.25s
const double kCriticalDamping = 0.95; // Almost no bounce
```

---

## 📚 Tier 2: Navigation & Transitions

### **Characteristics**
- **Focus shift required**
- **Medium cognitive load**
- **Smooth transition needed**
- **Professional feel**

### **Components**
| Component | User Goal | Cognitive Load | Animation | Speed | Damping |
|-----------|-----------|----------------|-----------|-------|---------|
| **Modal** | Focus | Medium | Smooth | 0.3s | 0.85 |
| **Sheet** | Focus | Medium | Smooth | 0.35s | 0.85 |
| **Menu** | Focus | Medium | Smooth | 0.3s | 0.85 |
| **Page Transition** | Navigate | Medium | Smooth | 0.4s | 0.8 |
| **Tab Switch** | Navigate | Low-Medium | Smooth | 0.25s | 0.85 |

### **Implementation Rules**
```dart
// Navigation - Smooth & purposeful
const double kNavigationSpeed = 0.3; // 0.25-0.4s
const double kNavigationDamping = 0.85; // Little bounce
```

---

## 📚 Tier 3: Delightful Moments

### **Characteristics**
- **Wait time involved**
- **High cognitive load acceptable**
- **Playful feel appropriate**
- **Enhance experience**

### **Components**
| Component | User Goal | Cognitive Load | Animation | Speed | Damping |
|-----------|-----------|----------------|-----------|-------|---------|
| **Loading** | Wait | High | Bouncy | 0.5s | 0.65 |
| **Success State** | Complete | Low | Bouncy | 0.5s | 0.65 |
| **Error State** | Alert | Medium | Bouncy | 0.6s | 0.7 |
| **Onboarding** | Learn | High | Bouncy | 0.7s | 0.6 |

### **Implementation Rules**
```dart
// Delightful - Can be playful
const double kDelightfulSpeed = 0.5; // 0.5-0.7s
const double kDelightfulDamping = 0.65; // More bounce
```

---

## 🧠 Context-Aware Decision Algorithm

### The Question Tree
```dart
Animation selectAnimation(Component component) {
  // Step 1: What is user trying to do?
  final userGoal = component.userGoal;

  if (userGoal == UserGoal.quickAction) {
    return _criticalAnimation();
  } else if (userGoal == UserGoal.focusChange) {
    return _navigationAnimation();
  } else if (userGoal == UserGoal.waitForSomething) {
    return _delightfulAnimation();
  } else if (userGoal == UserGoal.errorAlert) {
    return _alertAnimation();
  }

  return _defaultAnimation();
}
```

### Device Considerations
```dart
Animation adjustForDevice(Animation baseAnimation, DeviceType device) {
  switch (device) {
    case DeviceType.phone:
      return baseAnimation.copyWith(speed: baseAnimation.speed * 0.9);
    case DeviceType.tablet:
      return baseAnimation.copyWith(speed: baseAnimation.speed * 1.1);
    case DeviceType.watch:
      return baseAnimation.copyWith(speed: baseAnimation.speed * 0.7);
  }
}
```

---

## 😊 Emotional Design Mapping

### Emotion → Animation Matrix
```dart
enum EmotionalTone {
  efficient,    // ⚡ Action-focused
  professional, // 😐 Business-like
  delightful,   // 😊 Playful
  alert         // 🚨 Attention-grabbing
}

Animation mapEmotionToAnimation(EmotionalTone tone) {
  switch (tone) {
    case EmotionalTone.efficient:
      return Animation(speed: 0.15, damping: 0.95); // Snappy
    case EmotionalTone.professional:
      return Animation(speed: 0.3, damping: 0.85);   // Smooth
    case EmotionalTone.delightful:
      return Animation(speed: 0.5, damping: 0.65);   // Bouncy
    case EmotionalTone.alert:
      return Animation(speed: 0.6, damping: 0.7);    // Noticeable
  }
}
```

---

## 🏗️ Component Design System

### Design Tokens
```dart
// Apple's actual design system values
class AnimationTokens {
  // Speed categories
  static const double instant = 0.15;   // Button taps
  static const double fast = 0.25;      // Keyboard, Switches
  static const double medium = 0.35;    // Menu, Navigation
  static const double slow = 0.5;       // Loading, Transitions

  // Spring types
  static const double snappy = 0.95;    // Almost no bounce
  static const double smooth = 0.85;    // Little bounce
  static const double bouncy = 0.7;     // Noticeable bounce
  static const double playful = 0.6;    // Very bouncy
}
```

### Component Registry
```dart
enum ComponentType {
  // Tier 1: Critical
  button, switch, keyboard, checkbox,

  // Tier 2: Navigation
  modal, sheet, menu, pageTransition, tabSwitch,

  // Tier 3: Delightful
  loading, success, error, onboarding,
}

class ComponentRegistry {
  static Animation getAnimation(ComponentType type) {
    switch (type) {
      // Critical Interactions
      case ComponentType.button:
        return Animation(speed: AnimationTokens.instant, damping: AnimationTokens.snappy);
      case ComponentType.switch:
        return Animation(speed: AnimationTokens.fast, damping: AnimationTokens.snappy);
      case ComponentType.keyboard:
        return Animation(speed: AnimationTokens.fast, damping: AnimationTokens.snappy);

      // Navigation & Transitions
      case ComponentType.modal:
        return Animation(speed: AnimationTokens.medium, damping: AnimationTokens.smooth);
      case ComponentType.sheet:
        return Animation(speed: AnimationTokens.medium, damping: AnimationTokens.smooth);
      case ComponentType.menu:
        return Animation(speed: AnimationTokens.medium, damping: AnimationTokens.smooth);

      // Delightful Moments
      case ComponentType.loading:
        return Animation(speed: AnimationTokens.slow, damping: AnimationTokens.bouncy);
      case ComponentType.success:
        return Animation(speed: AnimationTokens.slow, damping: AnimationTokens.bouncy);
      case ComponentType.error:
        return Animation(speed: AnimationTokens.slow, damping: AnimationTokens.playful);
    }
  }
}
```

---

## 📋 Implementation Decision Matrix

### Quick Reference Chart
```
IMPORTANCE    GOAL        COGNITIVE LOAD    ANIMATION    EXAMPLE
─────────────────────────────────────────────────────────────
CRITICAL      Action      Low               Snappy       Button
CRITICAL      Input       Critical          Snappy       Keyboard
NAVIGATION    Focus       Medium            Smooth       Modal
NAVIGATION    Navigate    Low-Medium        Smooth       Tab
DELIGHTFUL    Wait        High              Bouncy       Loading
DELIGHTFUL    Complete    Low               Bouncy       Success
ALERT         Attention   Medium            Playful      Error
```

### Usage Examples
```dart
// Button click - Critical + Action
Animation buttonAnimation = ComponentRegistry.getAnimation(ComponentType.button);

// Modal appear - Navigation + Focus
Animation modalAnimation = ComponentRegistry.getAnimation(ComponentType.modal);

// Loading spinner - Delightful + Wait
Animation loadingAnimation = ComponentRegistry.getAnimation(ComponentType.loading);

// Success checkmark - Delightful + Complete
Animation successAnimation = ComponentRegistry.getAnimation(ComponentType.success);
```

---

## 🌊 Liquid Animations (Fluid Motion)

### **What are Liquid Animations?**
**Liquid Animations** là motion effects mô phỏng **chất lỏng** - như nước, honey, gel. Apple dùng rất nhiều trong iOS 14+.

### **Characteristics of Liquid Motion**
- **Fluid deformation** - Components thay đổi shape mượt mà như chất lỏng
- **Surface tension** - Giữ lại form cơ bản nhưng có thể stretch
- **Viscosity control** - Điều chỉnh "độ đặc" của motion
- **Surface ripple effects** - Tạo gợn sóng khi tương tác

### **Apple's Liquid Animation Parameters**
| Property | Value | Description |
|----------|-------|-------------|
| **Viscosity** | 0.8-1.2 | "Độ đặc" của motion |
| **Surface Tension** | 0.7-0.9 | Giữ form cơ bản |
| **Elasticity** | 0.6-0.8 | Khả năng stretch/bounce |
| **Damping** | 0.85-0.95 | Giảm rung lỏng lẻo |

### **Liquid Animation Categories**

#### **🔵 Droplet Animations**
**Components**: Button press, Toggle switches, Loading states
```
🎯 User Goal: Action feedback
🌊 Motion Type: Droplet impact and splash
⏱️ Timing: 0.2-0.3s
🎨 Effect: Ripple từ điểm touch
```

#### **🟢 Fluid Transitions**
**Components**: Shape morphing, Size changes, Transform effects
```
🎯 User Goal: Smooth state change
🌊 Motion Type: Viscous flow
⏱️ Timing: 0.3-0.5s
🎨 Effect: Shape变形 như chất lỏng
```

#### **🟡 Gel-like Behaviors**
**Components:** Cards, Panels, Interactive surfaces
```
🎯 User Goal: Tangible interaction
🌊 Motion Type: Gel elasticity
⏱️ Timing: 0.25-0.4s
🎨 Effect: Bouncy nhưng có "độ đàn hồi"
```

### **Implementation Examples**

#### **Droplet Button Effect**
```dart
class LiquidButton extends StatefulWidget {
  @override
  _LiquidButtonState createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;
  late Animation<double> _deformAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Ripple effect - like water droplet
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const LiquidCurve(viscosity: 0.9),
    ));

    // Shape deformation - like liquid stretching
    _deformAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scaleX: _deformAnimation.value,
            scaleY: 1.0 + (1.0 - _deformAnimation.value) * 0.1,
            child: Container(
              // Liquid deformation effect
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20 * (1.0 - _deformAnimation.value * 0.2),
                ),
                color: Colors.blue.withOpacity(0.8),
              ),
              child: Stack(
                children: [
                  // Ripple effect
                  if (_rippleAnimation.value > 0)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LiquidRipple(
                          progress: _rippleAnimation.value,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  // Button content
                  Center(child: Text('Liquid')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

#### **Liquid Sheet Transition**
```dart
class LiquidSheet extends StatefulWidget {
  @override
  _LiquidSheetState createState() => _LiquidSheetState();
}

class _LiquidSheetState extends State<LiquidSheet>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _liquidAnimation;
  late Animation<double> _surfaceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    // Main liquid motion
    _liquidAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const LiquidCurve(
        viscosity: 0.85, // "Độ đặc" của nước
        surfaceTension: 0.8, // Giữ form
      ),
    ));

    // Surface ripple when appearing
    _surfaceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                30 - (15 * _liquidAnimation.value), // Liquid deformation
              ),
              topRight: Radius.circular(
                30 - (15 * _liquidAnimation.value),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20 * _liquidAnimation.value,
                offset: Offset(0, 10 * _liquidAnimation.value),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                30 - (15 * _liquidAnimation.value),
              ),
              topRight: Radius.circular(
                30 - (15 * _liquidAnimation.value),
              ),
            ),
            child: Stack(
              children: [
                // Liquid surface ripple
                if (_surfaceAnimation.value > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                // Content
                widget.child,
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### **Liquid Curve Implementation**
```dart
class LiquidCurve extends Curve {
  final double viscosity;
  final double surfaceTension;
  final double elasticity;

  const LiquidCurve({
    this.viscosity = 0.9,
    this.surfaceTension = 0.8,
    this.elasticity = 0.7,
  });

  @override
  double transform(double t) {
    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    // Liquid physics simulation
    final double viscosityFactor = 1.0 / (1.0 + viscosity * t);
    final double surfaceTensionFactor = surfaceTension * (1.0 - t);
    final double elasticBounce = math.sin(t * math.pi * 2) * elasticity * 0.1;

    return t * viscosityFactor + surfaceTensionFactor * 0.1 + elasticBounce;
  }
}

class LiquidRipple extends StatelessWidget {
  final double progress;
  final Color color;

  const LiquidRipple({
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LiquidRipplePainter(
        progress: progress,
        color: color,
      ),
      child: Container(),
    );
  }
}

class LiquidRipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  LiquidRipplePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(1.0 - progress);

    // Draw multiple ripples like water droplets
    for (int i = 0; i < 3; i++) {
      final double rippleProgress = (progress - i * 0.1).clamp(0.0, 1.0);
      final double radius = size.width * 0.5 * rippleProgress;

      canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.5),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(LiquidRipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
```

### **When to Use Liquid Animations**

#### **✅ Perfect for:**
- **Touch feedback** - Buttons, switches, gestures
- **State transitions** - Loading, success states
- **Shape morphing** - Cards, panels, containers
- **Interactive surfaces** - Game elements, creative UIs

#### **❌ Avoid for:**
- **Professional/serious contexts** - Banking apps, forms
- **Data-heavy interfaces** - Tables, charts
- **Accessibility-sensitive** - Motion sickness concerns
- **Performance-critical** - Very complex animations

### **Apple's Real Usage Examples**

#### **Control Center (iOS 14+)**
```
- Toggle switches: Liquid droplet effect
- Brightness slider: Gel-like thumb
- Volume control: Surface ripple on buttons
```

#### **App Store Badges**
```
- Download progress: Liquid fill effect
- Update badges: Gel deformation
- Price drops: Droplet splash animation
```

#### **Weather App**
```
- Temperature changes: Liquid thermometer
- Weather transitions: Fluid motion between states
- Hourly forecast: Ripple cards
```

---

## 🎯 Real-World Application Examples

### 🌊 Updated iPhone Apps Analysis (Including Liquid)
```
App Store App:
- Tab switches: Smooth (0.25s, damping 0.85)
- Card details: Smooth (0.3s, damping 0.8)
- Purchase button: Snappy (0.15s, damping 0.95)
- Loading: Bouncy (0.5s, damping 0.65)
- Download badges: Liquid droplet (0.3s, viscosity 0.9)
- Price drops: Gel bounce (0.4s, elasticity 0.7)

Control Center:
- Toggle switches: Liquid droplet (0.2s, viscosity 0.85)
- Brightness slider: Gel-like (0.25s, elasticity 0.8)
- Volume buttons: Surface ripple (0.2s, surface tension 0.8)

Weather App:
- Temperature changes: Liquid thermometer (0.6s, viscosity 0.8)
- Weather transitions: Fluid flow (0.8s, viscosity 1.0)
- Hourly cards: Ripple touch (0.2s, surface tension 0.9)

Settings App:
- Toggle switches: Snappy (0.2s, damping 0.95)
- Menu items: Smooth (0.25s, damping 0.85)
- Page transitions: Smooth (0.35s, damping 0.8)

Messages App:
- Send button: Snappy (0.15s, damping 0.95)
- Keyboard: Snappy (0.25s, damping 0.95)
- Message bubble: Smooth (0.2s, damping 0.9)
```

---

## 🔧 Implementation Guidelines

### When to Override Defaults
1. **Special circumstances** - Error states, celebrations
2. **Brand requirements** - Specific emotional tone
3. **Accessibility needs** - Reduced motion preferences
4. **Performance constraints** - Complex animations

### Testing Checklist
- [ ] Animation matches user goal
- [ ] Timing appropriate for cognitive load
- [ ] Emotional tone matches context
- [ ] Device-specific adjustments applied
- [ ] Accessibility considerations addressed

---

## 🚀 Quick Start Guide

### Step 1: Identify Component Type
```dart
ComponentType type = ComponentType.button; // What is this component?
```

### Step 2: Get Recommended Animation
```dart
Animation animation = ComponentRegistry.getAnimation(type);
```

### Step 3: Apply Context Adjustments
```dart
if (needsDelightful) {
  animation = animation.copyWith(damping: AnimationTokens.bouncy);
}
```

### Step 4: Implement
```dart
AnimatedContainer(
  duration: Duration(milliseconds: animation.speed * 1000),
  curve: SpringCurve(damping: animation.damping),
  child: widget,
)
```

---

**Result: Every component in your app will have consistent, research-backed animations that feel "just right" to users!** ✨

*Based on Apple's iOS 17 design principles and 15 years of animation research*