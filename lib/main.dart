import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'env/env.dart';
import 'network/connection.dart';
import 'network/incoming/incoming_state.dart';
import 'utils/my_shared_preferences.dart';
import 'utils/my_snack_bar.dart';
import 'views/home.dart';
import 'views/login/login.dart';
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

    mySnackBar(context, serverError, clearServerError);
    mySnackBar(context, clientError, clearClientError);

    final connection = ref.watch(connectionStateProvider(Env.current));
    if (connection.connectionState.socketConnected == false) {
      connection.connect(); // went to background; will notify listeners
    }

    final socketConnected = ref.watch(incomingStateProvider
        .select((state) => state.connection.connectionState.socketConnected));

    final isLoginSent = useState(false);

    final outgoingHandlers = ref
        .watch(incomingStateProvider.select((state) => state.outgoingHandlers));

    if (Env.current.myAuthToken != null &&
        socketConnected &&
        isLoginSent.value == false) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        outgoingHandlers.sendLogin(Env.current.myAuthToken!);
      });
      isLoginSent.value = true;
    }

    // outgoing.login() should receive incoming.onPerson()
    final incomingPersonId =
        ref.watch(incomingStateProvider.select((state) => state.personId));

    final router = ref.watch(routerProvider);

    return MaterialApp(
      title: 'Shared Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
          child: connection.connectionState.socketConnected
              ? isLoginSent.value
                  ? incomingPersonId == -1
                      ? const Login()
                      : const Home()
                  : const Text("Logging in...")
              : const Text("Connecting...")),
      debugShowCheckedModeBanner: true,
      routes: router.widgetByNamedRoute,
    );
  }
}
