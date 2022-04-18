import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/network/incoming/incoming.dart';

import 'env/env.dart';
import 'network/connection.dart';
import 'notifications/notifications_plugin.dart';
import 'utils/my_shared_preferences.dart';
import 'views/login/login_or_home.dart';
import 'views/router.dart';

Future<void> main() async {
  Env.current.myAuthToken = await MySharedPreferences.getMyAuthToken();
  await NotificationsPlugin.instance.initInMain();

  runApp(const ProviderScope(
      // observers: [ProviderChangedLogger()],
      child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>(debugLabel: 'main');

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // unwraps state/incoming/outgoing
    final connection = ref.watch(connectionStateProvider(Env.current));
    if (connection.connectionState.socketConnected == false) {
      connection.connect(); // went to background; will notify listeners
    }

    final incoming = ref.watch(incomingStateProvider);

    return MaterialApp(
      title:
          incoming.socketConnected ? 'Shared Shopping List' : 'Connecting...',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scaffoldMessengerKey: messengerKey,
      home:
          // Builder(
          //   Builder makes Navigator available in its context (no exception anymore)
          //   builder: (context) =>
          const SafeArea(child: LoginOrHome()),
      // ),
      debugShowCheckedModeBanner: true,
      routes: router.widgetByNamedRoute,
    );
  }
}
