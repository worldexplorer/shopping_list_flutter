import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list_flutter/env/env.dart';
import 'package:shopping_list_flutter/views/home.dart';

import 'env/env_loader.dart';
import 'network/net_state.dart';

Future<void> main() async {
  final env = await EnvLoader.load();
  runApp(MyApp(env));
}

class MyApp extends StatelessWidget {
  Env env;
  const MyApp({this.env, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<NetState>(
        create: (context) => NetState(this.env),
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
