// https://github.com/TechieBlossom/flutter-samples/blob/master/menu_dashboard_layout.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/ui_notifier.dart';

import 'views.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widthAfterRebuild = MediaQuery.of(context).size.width;

    final screenWidth = useState(widthAfterRebuild);

    useEffect(() {
      screenWidth.value = widthAfterRebuild;
    }, [widthAfterRebuild]);

    final duration = useState(const Duration(milliseconds: 200));
    final menuVisibleController =
        useAnimationController(duration: duration.value);

    final ui = ref.watch(uiStateProvider);
    ui.menuVisibleController = menuVisibleController;

    final scaleAnimation = useState(
        Tween<double>(begin: 1, end: 0.8).animate(menuVisibleController));
    final menuScaleAnimation = useState(
        Tween<double>(begin: 0.5, end: 1).animate(menuVisibleController));
    final slideAnimation = useState(
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(menuVisibleController));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          SlideTransition(
            position: slideAnimation.value,
            child: ScaleTransition(
              scale: menuScaleAnimation.value,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Menu(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: duration.value,
            top: 0,
            bottom: 0,
            left: ui.isMenuVisible ? 0 : 0.4 * screenWidth.value,
            right: ui.isMenuVisible ? 0 : -0.2 * screenWidth.value,
            child: ScaleTransition(
              scale: scaleAnimation.value,
              child: Material(
                animationDuration: duration.value,
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                elevation: 8,
                color: backgroundColor,
                child: IgnorePointer(
                  // https://stackoverflow.com/questions/50600747/flutter-ignore-touch-events-on-a-widget
                  ignoring: !ui.isMenuVisible,
                  child: const ChatWrapperSlivers(),
                  // child: const ChatWrapperAppbar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
