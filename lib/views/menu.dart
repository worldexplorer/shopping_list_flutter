import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/routes.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';
import 'package:shopping_list_flutter/utils/ui_notifier.dart';

const Color backgroundColor = Color(0xFF4A4A58);

class Menu extends HookConsumerWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final ui = ref.watch(uiStateProvider);

    return Scaffold(
        backgroundColor: backgroundColor,
        // https://blog.logrocket.com/flutter-appbar-tutorial/
        // https://o7planning.org/12851/flutter-appbar
        // appBar: AppBar(
        //     leading: IconButton(
        //       icon: const Icon(
        //         Icons.arrow_back,
        //         size: 20,
        //       ),
        //       onPressed: () {
        //         ui.toMenuAndBack();
        //         Navigator.pop(context);
        //       },
        //     ),
        //     titleSpacing: 0,
        //     centerTitle: false),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 80),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, size: 20, color: Colors.white),
                onPressed: () {
                  ui.toMenuAndBack();
                  // Navigator.pop(context);
                },
              ),
            ),
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createMenuItems(router.visibleMenuItems)),
          ],
        ));
  }

  List<Widget> createMenuItems(List<RouteItem> routeItems) {
    final rendered = routeItems.map(createMenuItemfromRouteItem).toList();
    List<Widget> ret = [];
    rendered.forEach((routeItem) {
      ret.add(routeItem);
      ret.add(SizedBox(height: 30));
    });
    return ret;
  }

  Widget createMenuItemfromRouteItem(RouteItem routeItem) {
    return GestureDetector(
      onTap: () {
        StaticLogger.append('CLICKED ${routeItem.title}');
        // BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.DashboardClickedEvent);
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
