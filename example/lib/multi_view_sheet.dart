import 'package:flutter/material.dart';
import 'dynamic_height_sheet.dart';

/// Multi-view sheet with dynamic height and spring animations
/// Inspired by iOS TrayView with blur transitions
class MultiViewSheet extends StatefulWidget {
  final SpringAnimationType animationType;

  const MultiViewSheet({
    Key? key,
    this.animationType = SpringAnimationType.smooth,
  }) : super(key: key);

  @override
  State<MultiViewSheet> createState() => _MultiViewSheetState();
}

class _MultiViewSheetState extends State<MultiViewSheet>
    with TickerProviderStateMixin {
  CurrentView _currentView = CurrentView.actions;
  String _selectedAction = '';
  String _selectedPeriod = '';
  String _duration = '';

  // Animation controllers for view transitions
  late AnimationController _viewTransitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _viewTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _viewTransitionController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _viewTransitionController,
      curve: Curves.easeOutCubic,
    ));

    _viewTransitionController.forward();
  }

  @override
  void dispose() {
    _viewTransitionController.dispose();
    super.dispose();
  }

  void _switchView(CurrentView newView) {
    if (_currentView == newView) return;

    _viewTransitionController.reverse().then((_) {
      setState(() {
        _currentView = newView;
      });
      _viewTransitionController.forward();
    });
  }

  bool _canContinue() {
    switch (_currentView) {
      case CurrentView.actions:
        return _selectedAction.isNotEmpty;
      case CurrentView.periods:
        return _selectedPeriod.isNotEmpty;
      case CurrentView.keypad:
        return _duration.isNotEmpty;
    }
  }

  String _getButtonText() {
    switch (_currentView) {
      case CurrentView.actions:
        return 'Continue';
      case CurrentView.periods:
        return 'Subscribe';
      case CurrentView.keypad:
        return 'Subscribe';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE3E3E3),
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          // Content area with animated transitions
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: _buildCurrentView(),
            ),
          ),

          // Bottom button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _canContinue() ? _handleContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _getButtonText(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case CurrentView.actions:
        return _buildActionsView();
      case CurrentView.periods:
        return _buildPeriodsView();
      case CurrentView.keypad:
        return _buildKeypadView();
    }
  }

  Widget _buildActionsView() {
    return Container(
      key: const ValueKey('actions'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Choose Subscription',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...SubscriptionAction.actions.map((action) => _buildActionTile(action)),
        ],
      ),
    );
  }

  Widget _buildActionTile(SubscriptionAction action) {
    final isSelected = _selectedAction == action.title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAction = isSelected ? '' : action.title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007AFF).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF007AFF).withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                action.icon,
                color: isSelected ? const Color(0xFF007AFF) : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                action.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF007AFF) : Colors.black,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle,
              color: isSelected ? const Color(0xFF007AFF) : Colors.grey.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodsView() {
    return Container(
      key: const ValueKey('periods'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _switchView(CurrentView.actions),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const Expanded(
                child: Text(
                  'Choose Period',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance back button
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Choose the period you want\nto get subscribed.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.2,
            ),
            itemCount: SubscriptionPeriod.periods.length,
            itemBuilder: (context, index) {
              final period = SubscriptionPeriod.periods[index];
              final isSelected = _selectedPeriod == period.title;

              return GestureDetector(
                onTap: () {
                  if (period.title == 'Custom') {
                    _switchView(CurrentView.keypad);
                  } else {
                    setState(() {
                      _selectedPeriod = period.title;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF007AFF).withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        period.title,
                        style: TextStyle(
                          fontSize: period.title == 'Custom' ? 18 : 22,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? const Color(0xFF007AFF) : Colors.black,
                        ),
                      ),
                      if (period.value > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          period.value == 1 ? 'Month' : 'Months',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadView() {
    return Container(
      key: const ValueKey('keypad'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _switchView(CurrentView.periods),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const Expanded(
                child: Text(
                  'Custom Duration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance back button
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                _duration.isEmpty ? '0' : _duration,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              const Text(
                'Days',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.5,
            ),
            itemCount: 12, // 0-9 + Back
            itemBuilder: (context, index) {
              if (index == 9) {
                // Empty space
                return Container();
              } else if (index == 10) {
                // 0
                return _buildKeypadButton('0');
              } else if (index == 11) {
                // Back button
                return _buildKeypadButton('⌫', isBack: true);
              } else {
                // 1-9
                return _buildKeypadButton('${index + 1}');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String value, {bool isBack = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isBack) {
            if (_duration.isNotEmpty) {
              _duration = _duration.substring(0, _duration.length - 1);
            }
          } else {
            if (_duration.length < 3) {
              _duration += value;
            }
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isBack
              ? const Icon(
                  Icons.backspace_outlined,
                  size: 24,
                  color: Colors.black,
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }

  void _handleContinue() {
    switch (_currentView) {
      case CurrentView.actions:
        _switchView(CurrentView.periods);
        break;
      case CurrentView.periods:
        print('Subscribe to $_selectedAction for $_selectedPeriod');
        Navigator.pop(context);
        break;
      case CurrentView.keypad:
        print('Subscribe to $_selectedAction for $_duration days');
        Navigator.pop(context);
        break;
    }
  }
}

enum CurrentView {
  actions,
  periods,
  keypad,
}

class SubscriptionAction {
  final String title;
  final IconData icon;

  const SubscriptionAction({
    required this.title,
    required this.icon,
  });

  static const List<SubscriptionAction> actions = [
    SubscriptionAction(title: 'Game Pass', icon: Icons.sports_esports),
    SubscriptionAction(title: 'PS Plus', icon: Icons.gamepad),
    SubscriptionAction(title: 'iCloud+', icon: Icons.cloud),
    SubscriptionAction(title: 'Apple TV', icon: Icons.tv),
  ];
}

class SubscriptionPeriod {
  final String title;
  final int value;

  const SubscriptionPeriod({
    required this.title,
    required this.value,
  });

  static const List<SubscriptionPeriod> periods = [
    SubscriptionPeriod(title: '1', value: 1),
    SubscriptionPeriod(title: '3', value: 3),
    SubscriptionPeriod(title: '5', value: 5),
    SubscriptionPeriod(title: '7', value: 7),
    SubscriptionPeriod(title: '9', value: 9),
    SubscriptionPeriod(title: 'Custom', value: 0),
  ];
}