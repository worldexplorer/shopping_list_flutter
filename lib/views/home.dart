// https://github.com/TechieBlossom/flutter-samples/blob/master/menu_dashboard_layout.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifications/notification_clicked_handler.dart';
import 'menu.dart';
import 'my_router.dart';
// import '../notifications/notifications_plugin.dart';
import 'theme.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    final singleInstance =
        useState(NotificationClickedHandler(context, router.currentRoom.path));

    return Scaffold(
      backgroundColor: menuBackgroundColor,
      body: router.rooms.widget(context),
      drawer: const Menu(),
    );
  }

  // @override
  // dispose() {
  //   NotificationsPlugin.instance.disposeInWidget();
  // }
}
