import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

import '../../env/env.dart';
import '../../network/connection.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/my_snack_bar.dart';
import '../../utils/theme.dart';
import '../../utils/ui_state.dart';
import '../router.dart';
import 'half-tiger.dart';

class LoginOrHome extends HookConsumerWidget {
  const LoginOrHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);

    final connection = ref.watch(connectionStateProvider(Env.current));
    if (connection.connectionState.socketConnected == false) {
      connection.connect(); // went to background; will notify listeners
    }

    final socketConnected = ref.watch(incomingStateProvider
        .select((state) => state.connection.connectionState.socketConnected));

    final isLoginSent = useState(false);

    final outgoingHandlers = ref
        .watch(incomingStateProvider.select((state) => state.outgoingHandlers));

    final shouldLogIn = Env.current.myAuthToken != null && socketConnected;

    if (shouldLogIn && isLoginSent.value == false) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        outgoingHandlers.sendLogin(Env.current.myAuthToken!);
        isLoginSent.value = true;
        ui.rebuild();
      });
    }

    // outgoing.login() should receive incoming.onPerson()
    final incomingPersonId =
        ref.watch(incomingStateProvider.select((state) => state.personId));
    final router = ref.watch(routerProvider);

    final redirectDebounced = useState(false);
    buildSnackBar(context, ref, clearServerErrorCallback: (String serverError) {
      if (redirectDebounced.value == false) {
        StaticLogger.append(serverError);
        final redirectToLogin = serverError.contains('No AuthToken found');
        if (redirectToLogin) {
          redirectDebounced.value = true;
          Future.delayed(const Duration(milliseconds: 100), () async {
            Navigator.pushNamed(context, router.login.path);
          });
        }
      }
    });

    Widget loginOrHome() {
      if (connection.connectionState.socketConnected) {
        if (shouldLogIn) {
          if (isLoginSent.value) {
            if (incomingPersonId == -1) {
              return HalfTiger(
                message: "Logging in...",
                onTap: () {
                  Navigator.pushNamed(context, router.log.path);
                },
              );
            } else {
              return router.home.widget(context);
            }
          } else {
            return HalfTiger(
              message: "Logging in..",
              onTap: () {
                Navigator.pushNamed(context, router.log.path);
              },
            );
          }
        } else {
          return router.login.widget(context);
        }
      } else {
        return HalfTiger(
          message: "Connecting...",
          onTap: () {
            Navigator.pushNamed(context, router.log.path);
          },
        );
      }
    }

    return Scaffold(backgroundColor: chatBackground, body: loginOrHome());
  }
}
