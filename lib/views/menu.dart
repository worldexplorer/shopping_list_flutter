//https://blogmarch.com/flutter-left-right-navigation-drawer/

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/static_logger.dart';
import '../utils/ui_state.dart';
import 'router.dart';

class Menu extends HookConsumerWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final ui = ref.watch(uiStateProvider);

    // final actionCompleted = useState(false);
    // if (actionCompleted.value) {
    //   return const SizedBox();
    // }

    return Drawer(
      elevation: 10.0,
      child: ListView(
        children: <Widget>[
          // DrawerHeader(
          //   decoration: BoxDecoration(color: Colors.grey.shade500),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: <Widget>[
          //       CircleAvatar(
          //         backgroundImage: NetworkImage(
          //             'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
          //         radius: 40.0,
          //       ),
          //       Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Text(
          //             'Tom Cruise',
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.white,
          //                 fontSize: 25.0),
          //           ),
          //           SizedBox(height: 10.0),
          //           Text(
          //             'tomcruise@gmail.com',
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.white,
          //                 fontSize: 14.0),
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          ...createMenuItems(router.visibleMenuItems, context, () {
            // actionCompleted.value = true;
            Navigator.pop(context);
          })
        ],
      ),
    );
  }

  List<Widget> createMenuItems(List<MenuItem> routeItems, BuildContext context,
      Function? onActionCompleted) {
    List<Widget> ret = [];
    for (var routeItem in routeItems) {
      if (routeItem.isVisibleInMenu == false) {
        continue;
      }

      final rendered = ListTile(
        // leading: const Icon(Icons.home),
        title: Text(routeItem.title, style: const TextStyle(fontSize: 18)),
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
            if (onActionCompleted != null) {
              onActionCompleted();
            }
          }
        },
      );

      ret.add(rendered);
    }
    return ret;
  }
}
