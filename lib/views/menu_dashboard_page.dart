// https://github.com/TechieBlossom/flutter-samples/blob/master/menu_dashboard_layout.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/ui_notifier.dart';

import 'chat.dart';

final Color backgroundColor = const Color(0xFF4A4A58);

class MenuDashboardPage extends HookConsumerWidget {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    final ui = ref.watch(uiStateProvider);

    final duration = useState<Duration>(const Duration(milliseconds: 300));

    // final _controller = AnimationController(vsync: this, duration: duration);
    // https://pub.dev/packages/flutter_hooks/example
    final _controller =
        useAnimationController(duration: const Duration(milliseconds: 300));

    final _scaleAnimation = useState<Animation<double>>(
        Tween<double>(begin: 1, end: 0.8).animate(_controller));
    final _menuScaleAnimation = useState<Animation<double>>(
        Tween<double>(begin: 0.5, end: 1).animate(_controller));
    final _slideAnimation = useState<Animation<Offset>>(
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(_controller));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          SlideTransition(
            position: _slideAnimation.value,
            child: ScaleTransition(
              scale: _menuScaleAnimation.value,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text("Dashboard",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                      SizedBox(height: 10),
                      Text("Messages",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                      SizedBox(height: 10),
                      Text("Utility Bills",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                      SizedBox(height: 10),
                      Text("Funds Transfer",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                      SizedBox(height: 10),
                      Text("Branches",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: duration.value,
            top: 0,
            bottom: 0,
            left: ui.isCollapsed ? 0 : 0.6 * screenWidth,
            right: ui.isCollapsed ? 0 : -0.2 * screenWidth,
            child: ScaleTransition(
              scale: _scaleAnimation.value,
              child: Material(
                animationDuration: duration.value,
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                elevation: 8,
                color: backgroundColor,
                child: const Chat(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
