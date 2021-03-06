import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/static_logger.dart';
import '../../utils/ui_state.dart';
import '../my_router.dart';
import '../theme.dart';

class Menu extends HookConsumerWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final ui = ref.watch(uiStateProvider);

    return Scaffold(
        backgroundColor: menuBackgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 20, 0, 80),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                onPressed: () {
                  ui.toMenuAndBack();
                  // Navigator.pop(context);
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        createMenuItems(router.visibleMenuItems, context))),
          ],
        ));
  }

  List<Widget> createMenuItems(
      List<MenuItem> routeItems, BuildContext context) {
    final rendered =
        routeItems.map((x) => createMenuItemFromRouteItem(x, context)).toList();
    List<Widget> ret = [];
    for (var routeItem in rendered) {
      ret.add(routeItem);
      ret.add(const SizedBox(height: 30));
    }
    return ret;
  }

  Widget createMenuItemFromRouteItem(MenuItem routeItem, BuildContext context) {
    return GestureDetector(
      onTap: () {
        StaticLogger.append('CLICKED ${routeItem.title}');
        if (routeItem is RouteMenuItem) {
          RouteMenuItem routeMenuItem = routeItem;
          Navigator.pushNamed(
            context,
            routeMenuItem.path,
          );
        }
        if (routeItem is ActionMenuItem) {
          ActionMenuItem actionMenuItem = routeItem;
          actionMenuItem.action();
        }
      },
      child: Text(routeItem.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: routeItem.isSelectedInMenu
                ? FontWeight.w900
                : FontWeight.normal,
          )),
    );
  }
}
