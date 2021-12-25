import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_flutter/utils/ui_notifier.dart';
import 'package:shopping_list_flutter/views/home.dart';

import 'env/env.dart';
import 'env/env_loader.dart';
import 'network/connection.dart';
import 'network/connection_notifier.dart';
import 'network/incoming/incoming_notifier.dart';
import 'network/outgoing/outgoing.dart';
import 'views/menu_dashboard_page.dart';

Future<void> main() async {
  // TODO: move somewhere to let UI draw spinner & NetLog panel
  final env = await EnvLoader.load();
  runApp(MyApp(env: env));
}

class MyApp extends StatelessWidget {
  final Env env;
  late UiNotifier uiNotifier;
  late Connection connection;

  MyApp({required this.env, Key? key}) : super(key: key) {
    uiNotifier = UiNotifier();
    connection = Connection(env);
    connection.connect();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final providers = [
      ChangeNotifierProvider<ConnectionNotifier>(
          create: (context) => connection.connectionNotifier),
      ChangeNotifierProvider<UiNotifier>(create: (context) => uiNotifier),
      ChangeNotifierProvider<IncomingNotifier>(
          create: (context) => connection.incomingNotifier),
      Provider<Outgoing>(create: (context) => connection.outgoingNotifier),
    ];

    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          title: 'Shopping List',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: HomeWidget(),
          home: SafeArea(child: MenuDashboardPage()),
          debugShowCheckedModeBanner: true,
        ));
  }
}
