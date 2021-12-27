import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/provider_changed_logger.dart';
import 'package:shopping_list_flutter/views/home.dart';

import 'env/env.dart';
import 'env/env_loader.dart';
import 'network/connection.dart';
import 'views/menu_dashboard_page.dart';

Future<void> main() async {
  // TODO: move somewhere to let UI draw spinner & NetLog panel
  final env = await EnvLoader.load();
  runApp(ProviderScope(
      observers: [ProviderChangedLogger()], child: MyApp(env: env)));
}

class MyApp extends ConsumerWidget {
  final Env env;

  MyApp({required this.env, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // created and bound: IncomingHandlers OutgoingHandlers
    final connection = ref.watch(connectionStateProvider(env));
    connection.connect(); // went to background; will notify listeners

    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomeWidget(),
      home: SafeArea(child: MenuDashboardPage()),
      debugShowCheckedModeBanner: true,
    );
  }
}
