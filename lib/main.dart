import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_flutter/utils/ui_notifier.dart';
import 'package:shopping_list_flutter/views/home.dart';

import 'env/env_loader.dart';
import 'network/connection.dart';
import 'network/connection_notifier.dart';
import 'network/incoming/incoming_notifier.dart';
import 'network/outgoing/outgoing_notifier.dart';

Future<void> main() async {
  final env = await EnvLoader.load();
  runApp(MyApp(env: env));
}

class MyApp extends StatelessWidget {
  final Env env;
  const MyApp({required this.env, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final uiNotifier = UiNotifier();

    final connection = Connection(env);
    connection.connect();

    final providers = [
      ChangeNotifierProvider<ConnectionNotifier>(
          create: (context) => connection.connectionNotifier),
      ChangeNotifierProvider<UiNotifier>(create: (context) => uiNotifier),
      ChangeNotifierProvider<IncomingNotifier>(
          create: (context) => connection.incomingNotifier),
      ChangeNotifierProvider<OutgoingNotifier>(
          create: (context) => connection.outgoingNotifier),
    ];

    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          title: 'Shopping List',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomeWidget(),
          debugShowCheckedModeBanner: true,
        ));
  }
}
