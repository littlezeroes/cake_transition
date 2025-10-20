# Cake Transitions

A Flutter showcase demonstrating smooth iOS-style page transitions and sheet animations with custom timing and curves.

## Features

### Page Transitions
- **iOS Push Transition**: Native iOS-style slide animation with shadow effects
- **Custom Timing**: 350ms forward, 250ms reverse with smooth curves
- **Drag Gesture**: Full iOS-style swipe-to-back support
- **Bottom-Aligned Layout**: Images positioned from bottom edge (bot = 0)

### Sheet Animations
- **Nathan Gitter Spring Values**: Authentic iOS spring physics (WWDC 2018)
- **Non-Interactive Spring**: stiffness=246.74, damping=31.42
- **Duration**: 285ms with natural physics-based settling
- **Background Overlay**: Semi-transparent overlay with bottom sheet

### Screen Navigation
- **Screen 1**: Displays 1.png with invisible touch areas
  - Middle touch (300x400): Navigate to Screen 2
  - Top-left touch (100x100): Back button
- **Screen 2**: Displays 2.png with back button
- **Screen 3**: Displays bg.jpeg with SpringBottomSheet trigger

## Installation

```bash
git clone https://github.com/huygeek/cake_transition.git
cd cake_transition
cd example
flutter pub get
```

## Running the App

### Mobile
```bash
flutter run
```

### Web (Chrome)
```bash
flutter run -d chrome
```

## Usage

### Page Transitions

```dart
import 'package:flutter/cupertino.dart';

// Navigate with iOS-style transition
Navigator.push(
  context,
  CupertinoPageRoute(
    builder: (context) => MyScreen(),
  ),
);
```

### Custom Cake Page Route

```dart
import 'cake_transition.dart';

// Custom iOS transition with custom timing
Navigator.push(
  context,
  CakePageRoute(screen: 1), // 1: 1.png, 2: 2.png, 3: bg.jpeg
);
```

### Spring Bottom Sheet

```dart
import 'spring_bottom_sheet.dart';

// Show sheet with Nathan Gitter spring values
SpringBottomSheet.show(
  context: context,
  springType: SpringType.fast, // Uses Nathan Gitter values
  builder: (context) => MySheetContent(),
);
```

## Implementation Details

### Page Route Configuration
```dart
class CakePageRoute extends CupertinoPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);
}
```

### Spring Physics (Nathan Gitter WWDC 2018)
```dart
// Non-Interactive Spring
// dampingRatio: 1.0, response: 0.4s
// stiffness = (2π/response)² = 246.74
// damping = 4π×dampingRatio/response = 31.42
```

### Image Layout
```dart
Image.asset(
  'assets/1.png',
  width: double.infinity,
  fit: BoxFit.fitWidth,
  alignment: Alignment.bottomCenter, // bot = 0
)
```

## Project Structure

```
lib/
├── cake_transition.dart      # Custom page route implementation
├── spring_bottom_sheet.dart   # Nathan Gitter spring animations
└── pink_button.dart          # Reusable pink button component

example/
├── lib/
│   ├── main.dart            # Main app with 2 animations
│   └── assets/              # Images (1.png, 2.png, bg.jpeg, Sheet.png)
└── pubspec.yaml             # Dependencies and asset configuration
```

## Assets

### Images Required
- `assets/1.png` - First screen background
- `assets/2.png` - Second screen background
- `assets/bg.jpeg` - Third screen background
- `assets/Sheet.png` - Bottom sheet content

### Touch Areas
- **Back Button**: 100x100 at top-left corner
- **Navigation**: 300x400 at screen center

## Technical Specifications

### Animation Timing
- Page Forward: 350ms
- Page Back: 250ms
- Sheet Duration: 285ms (physics-based ~350ms)

### Spring Values
- Stiffness: 246.74 (Nathan Gitter non-interactive)
- Damping: 31.42
- Mass: 1.0

### Image Sizing
- Fit: `BoxFit.fitWidth`
- Alignment: `Alignment.bottomCenter`
- Width: `double.infinity`

## Contributing

Feel free to submit issues and enhancement requests!

## License

MIT License - feel free to use this code in your projects.