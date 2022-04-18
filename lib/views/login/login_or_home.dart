import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shopping_list_flutter/utils/static_logger.dart';

import '../../env/env.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/my_snack_bar.dart';
import '../../utils/ui_state.dart';
import '../router.dart';
import '../theme.dart';
import 'half-tiger.dart';

class LoginOrHome extends HookConsumerWidget {
  const LoginOrHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiStateProvider);
    final incoming = ref.watch(incomingStateProvider);

    final isLoginSent = useState(false);

    final shouldLogIn =
        Env.current.myAuthToken != null && incoming.socketConnected
        // && incoming.personNullable == null // << LOGIN deduplicated
        ;

    if (shouldLogIn && isLoginSent.value == false) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        incoming.outgoingHandlers
            .sendLogin(Env.current.myAuthToken!, 'LoginOrHome');
        isLoginSent.value = true;
        // ui.rebuild(); // FIXME: emulator logs in via local stored authToken here
      });
    }

    // outgoing.login() should receive incoming.onPerson()
    final incomingPersonId =
        ref.watch(incomingStateProvider.select((state) => state.personId));
    final incomingPersonName =
        ref.watch(incomingStateProvider.select((state) => state.personName));
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
      } else {
        StaticLogger.append(
            'extra re-render while redirectDebounced.value == true');
      }
    });

    Widget loginOrHome() {
      if (incoming.socketConnected) {
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
              if (incomingPersonName.isEmpty) {
                return router.yourName.widget(context);
              } else {
                return router.home.widget(context);
              }
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
