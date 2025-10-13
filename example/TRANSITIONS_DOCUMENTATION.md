# Transitions Documentation

## Table of Contents
1. [Floating Navbar Transitions](#floating-navbar-transitions)
2. [Pills Component Transitions](#pills-component-transitions)
3. [Content Transitions](#content-transitions)
4. [Page Navigation Transitions](#page-navigation-transitions)
5. [Performance Optimizations](#performance-optimizations)

---

## 1. Floating Navbar Transitions

### 1.1 Entrance Animation (On App Load)

**Components:**
- Slide Animation
- Fade Animation
- Scale Animation

**Specifications:**

| Property | Mobile | Web/Chrome |
|----------|--------|------------|
| **Duration** | 600ms | 300ms |
| **Slide Distance** | 80px → 0px | 30px → 0px |
| **Fade** | 0.0 → 1.0 | 0.0 → 1.0 |
| **Scale** | 0.9 → 1.0 | Disabled (1.0) |
| **Curve** | Cubic(0.25, 0.1, 0.25, 1.0) | Curves.easeOut |
| **Delay** | Post-frame callback | Immediate |

**Code Example:**
```dart
// Mobile
_navbarSlideAnimation = Tween<double>(
  begin: 80.0,
  end: 0.0,
).animate(CurvedAnimation(
  parent: _navbarController,
  curve: const Cubic(0.25, 0.1, 0.25, 1.0), // iOS spring curve
));

// Web/Chrome
_navbarSlideAnimation = Tween<double>(
  begin: 30.0,
  end: 0.0,
).animate(CurvedAnimation(
  parent: _navbarController,
  curve: Curves.easeOut, // Simpler for performance
));
```

### 1.2 Icon Selection Animation

**Specifications:**

| Property | Mobile | Web/Chrome |
|----------|--------|------------|
| **Duration** | 150ms | Disabled |
| **Container Background** | Transparent → #1E3A8A | Instant |
| **Icon Color** | #9CA3AF → White | Instant |
| **Label Weight** | w500 → w600 | Instant |

---

## 2. Pills Component Transitions

### 2.1 Pill Selection Animation

**Specifications:**

| Property | Mobile | Web/Chrome |
|----------|--------|------------|
| **Duration** | 200ms | 150ms |
| **Background** | #F2F1F7 → #D6F7FC | #F2F1F7 → #D6F7FC |
| **Text Color** | #394860 → #1A5997 | #394860 → #1A5997 |
| **Scale on Press** | 1.0 → 0.95 → 1.0 | Disabled |
| **Shadow** | None → Subtle | None → Subtle |
| **Curve** | Curves.easeOutCubic | Curves.easeOut |

**Code Example:**
```dart
AnimatedContainer(
  duration: kIsWeb 
      ? const Duration(milliseconds: 150)
      : const Duration(milliseconds: 200),
  curve: kIsWeb ? Curves.easeOut : Curves.easeOutCubic,
  decoration: BoxDecoration(
    color: isSelected 
        ? const Color(0xFFD6F7FC)  // Selected
        : const Color(0xFFF2F1F7), // Unselected
    borderRadius: BorderRadius.circular(1000),
    boxShadow: isSelected
        ? [BoxShadow(
            color: const Color(0xFF1A5997).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )]
        : [],
  ),
)
```

### 2.2 Content Switch Animation

**Specifications:**

| Property | Value |
|----------|-------|
| **Duration** | 200ms (Web: 150ms) |
| **Fade** | 0.0 → 1.0 |
| **Slide** | Offset(0, 0.01) → Offset.zero |
| **Curve** | Cubic(0.25, 0.1, 0.25, 1.0) |
| **Restart Mode** | forward(from: 0.0) |

---

## 3. Content Transitions

### 3.1 Progressive Loading Animation

Each content section (Portfolio, Markets, Trade, Wallet) has unique loading animations:

#### Portfolio Tab
**Specifications:**

| Property | Header | Cards |
|----------|--------|-------|
| **Duration** | 400ms | 300ms + (index * 50ms) |
| **Transform** | Translate Y: 10px → 0 | Scale: 0.95 → 1.0 |
| **Opacity** | 0 → 1 | 0 → 1 |
| **Curve** | Curves.easeOut | Curves.easeOutCubic |
| **Stagger** | None | 50ms between items |

#### Markets Tab
**Specifications:**

| Property | Header | Cards |
|----------|--------|-------|
| **Duration** | 400ms | 300ms + (index * 50ms) |
| **Transform** | Translate Y: 10px → 0 | Translate X: 20px → 0 |
| **Opacity** | 0 → 1 | 0 → 1 |
| **Curve** | Curves.easeOut | Curves.easeOutCubic |

#### Trade Tab
**Specifications:**

| Property | Header | Cards |
|----------|--------|-------|
| **Duration** | 400ms | 350ms + (index * 60ms) |
| **Transform** | Translate Y: 10px → 0 | Scale elastic bounce |
| **Opacity** | 0 → 1 | 0 → 1 |
| **Curve** | Curves.easeOut | Curves.easeOutBack |

#### Wallet Tab
**Specifications:**

| Property | Header | Cards |
|----------|--------|-------|
| **Duration** | 400ms | 300ms + (index * 50ms) |
| **Transform** | Translate Y: 10px → 0 | 3D rotation + translate |
| **Opacity** | 0 → 1 | 0 → 1 |
| **Curve** | Curves.easeOut | Cubic(0.25, 0.46, 0.45, 0.94) |
| **3D Effect** | None | rotateX(0.1 → 0) |

**Code Example (Wallet 3D Effect):**
```dart
Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001) // Perspective
    ..rotateX(0.1 * (1 - value))
    ..translate(0.0, 20 * (1 - value), 0.0),
  alignment: Alignment.center,
  child: Opacity(
    opacity: value,
    child: _buildWalletCard(...),
  ),
)
```

---

## 4. Page Navigation Transitions

### 4.1 iOS-Style Page Transition

**File:** `perfect_ios_transition.dart`

**Specifications:**

| Property | Value |
|----------|-------|
| **Duration** | 350ms |
| **Slide Distance** | Full width → 0 |
| **Parallax** | Previous page: 0 → -0.33 width |
| **Shadow** | Progressive shadow on entering page |
| **Curve** | CupertinoPageTransition curve |

### 4.2 Web Optimized Transition

**Specifications:**

| Platform | Transition Type |
|----------|----------------|
| **Windows** | FadeUpwardsPageTransitionsBuilder |
| **Linux** | FadeUpwardsPageTransitionsBuilder |
| **macOS** | FadeUpwardsPageTransitionsBuilder |
| **Mobile** | Default platform transition |

---

## 5. Performance Optimizations

### 5.1 Chrome-Specific Optimizations

**CSS Hardware Acceleration:**
```css
.flt-scene-host {
  transform: translateZ(0);
  will-change: transform;
}

canvas {
  image-rendering: optimizeSpeed;
  image-rendering: -webkit-optimize-contrast;
}
```

### 5.2 Animation Reduction Strategy

**Web/Chrome Optimizations:**
1. **Disabled Animations:**
   - Scale animations on navbar
   - Icon tap animations
   - Complex spring curves
   - Animations for list items 3+ (progressive loading)

2. **Reduced Durations:**
   - Navbar: 600ms → 300ms
   - Pills: 200ms → 150ms
   - Content: 200ms → 150ms

3. **Simplified Curves:**
   - iOS springs → Linear/EaseOut
   - ElasticOut → EaseOutBack
   - Complex cubics → Simple easing

### 5.3 Timing Comparison Table

| Component | Mobile Duration | Web Duration | Reduction |
|-----------|----------------|--------------|-----------|
| **Navbar Entry** | 600ms | 300ms | 50% |
| **Pill Selection** | 200ms | 150ms | 25% |
| **Content Fade** | 200ms | 150ms | 25% |
| **Icon Animation** | 150ms | Disabled | 100% |
| **Progressive Load** | 300-500ms | 200ms | 40-60% |

---

## Usage Examples

### Example 1: Implementing a Custom Transition

```dart
class CustomTransition extends StatefulWidget {
  @override
  _CustomTransitionState createState() => _CustomTransitionState();
}

class _CustomTransitionState extends State<CustomTransition> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kIsWeb 
          ? const Duration(milliseconds: 200)  // Faster for web
          : const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: kIsWeb 
          ? Curves.easeOut  // Simple for web
          : Curves.easeOutCubic,  // Smooth for mobile
    );
    
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: YourWidget(),
    );
  }
}
```

### Example 2: Staggered List Animation

```dart
List.generate(items.length, (index) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: Duration(
      milliseconds: kIsWeb 
          ? 200  // Fast base for web
          : 300 + (index * 50),  // Staggered for mobile
    ),
    curve: kIsWeb ? Curves.linear : Curves.easeOutCubic,
    builder: (context, value, child) {
      // Skip animation for items 3+ on web
      if (kIsWeb && index > 2) {
        return child!;
      }
      
      return Transform.scale(
        scale: 0.95 + (0.05 * value),
        child: Opacity(
          opacity: value,
          child: child,
        ),
      );
    },
    child: ListItem(data: items[index]),
  );
})
```

---

## Best Practices

1. **Always check platform:** Use `kIsWeb` to provide optimized animations
2. **Reduce complexity on web:** Simpler curves and shorter durations
3. **Use hardware acceleration:** Transform properties over position changes
4. **Batch animations:** Group related animations to reduce repaints
5. **Progressive enhancement:** Show content immediately on web, animate on mobile
6. **Test performance:** Use Chrome DevTools Performance tab to measure

---

## Animation Curves Reference

| Curve Name | Usage | Platform |
|------------|-------|----------|
| **Cubic(0.25, 0.1, 0.25, 1.0)** | iOS default | Mobile |
| **Cubic(0.25, 0.46, 0.45, 0.94)** | iOS spring | Mobile |
| **Curves.easeOutCubic** | Smooth deceleration | Both |
| **Curves.easeOut** | Simple deceleration | Web |
| **Curves.linear** | No acceleration | Web |
| **Curves.easeOutBack** | Slight overshoot | Mobile |
| **Curves.elasticOut** | Bouncy effect | Mobile only |

---

*Last Updated: 2024*
*Version: 1.0.0*