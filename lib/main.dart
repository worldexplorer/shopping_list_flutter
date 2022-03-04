import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'env/env.dart';
import 'network/incoming/incoming_state.dart';
import 'utils/my_shared_preferences.dart';
import 'utils/my_snack_bar.dart';
import 'views/login/login_or_home.dart';
import 'views/router.dart';

Future<void> main() async {
  Env.current.myAuthToken = await MySharedPreferences.getMyAuthToken();
  runApp(const ProviderScope(
      // observers: [ProviderChangedLogger()],
      child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverError =
        ref.watch(incomingStateProvider.select((state) => state.serverError));

    final clearServerError = ref
        .watch(incomingStateProvider.select((state) => state.clearServerError));

    final clientError =
        ref.watch(incomingStateProvider.select((state) => state.clientError));

    final clearClientError = ref
        .watch(incomingStateProvider.select((state) => state.clearClientError));

    final messengerKey = GlobalKey<ScaffoldMessengerState>();
    mySnackBar(context, serverError, clearServerError);
    mySnackBar(context, clientError, clearClientError);

    final router = ref.watch(routerProvider);

    return MaterialApp(
      title: 'Shared Shopping List',
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
