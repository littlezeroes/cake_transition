# Cake Animation

Flutter animations and UI components showcase with smooth transitions and interactive elements.

## Features

### Tab Navigation
- Animated tab bar with smooth shape indicator (350ms easeInOutCubic)
- Drag gesture support for intuitive tab switching
- Responsive touch areas for better usability
- Portrait-only orientation lock

### Page Transitions
- iOS-style page transitions with custom curves
- Swipeable page routes
- Multiple transition styles (fade, slide, scale)

### Interactive Components
- Animated cards with flip effects
- Custom dialogs with smooth animations
- Toast notifications
- OTP input screens
- Bottom sheets

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK

### Installation

```bash
git clone https://github.com/huygeek/cake_animation.git
cd cake_animation
flutter pub get
```

### Run Example

```bash
cd example
flutter run
```

## Project Structure

```
lib/
├── floating_navbar.dart          # Main navigation component
├── floating_navbar_item.dart     # Navigation item model
└── animation_constants.dart      # Animation configuration

example/lib/
├── main.dart                     # Main app with tab navigation
├── card_detail_screen.dart       # Card animations demo
├── otp_screen.dart              # OTP input UI
├── custom_dialog.dart           # Dialog component
├── custom_toast.dart            # Toast notifications
├── swipeable_page_route.dart    # Page transition implementation
└── ...                          # More examples
```

## Tab Navigation Example

```dart
import 'package:flutter/material.dart';

class FigmaTabScreen extends StatefulWidget {
  @override
  _FigmaTabScreenState createState() => _FigmaTabScreenState();
}

class _FigmaTabScreenState extends State<FigmaTabScreen> {
  int _selectedTabIndex = 0;
  final List<String> tabs = ['Tài sản', 'Danh mục', 'Phải trả', 'Quyền', 'Tab'];

  @override
  Widget build(BuildContext context) {
    // Tab bar with animated indicator
    // Supports both tap and drag gestures
    // 350ms easeInOutCubic animation
  }
}
```

## Customization

### Animation Constants

All animations use consistent timing and curves defined in `animation_constants.dart`:
- Tab indicator: 350ms with `Curves.easeInOutCubic`
- Page transitions: 250ms for forward, 220ms for reverse
- Card flips: Custom timing based on interaction

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

Built with Flutter and inspired by modern mobile UI/UX patterns.
