// https://www.loginradius.com/blog/async/guest-post/authenticating-flutter-apps/

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env/env.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/my_snack_bar.dart';
import '../my_router.dart';
import '../theme.dart';
import 'login.dart';

class YourName extends HookConsumerWidget {
  static final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: 'YourName');

  const YourName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingPersonId =
        ref.watch(incomingStateProvider.select((state) => state.personId));
    final incomingPersonName =
        ref.watch(incomingStateProvider.select((state) => state.personName));

    final router = ref.watch(routerProvider);

    final incoming = ref.watch(incomingStateProvider);
    mySnackBar(context, incoming.serverError, incoming.clearServerError);
    mySnackBar(context, incoming.clientError, incoming.clearClientError);

    if (incomingPersonName.isNotEmpty) {
      return router.home.widget(context);
    }

    final nameFocusNode = useFocusNode(
      debugLabel: 'nameFocusNode',
    );

    final nameInputCtrl =
        useTextEditingController.fromValue(TextEditingValue.empty);

    final isNetworkPending = useState(false);

    _handleSend() async {
      if (_formKey.currentState!.validate() == false) {
        return;
      }

      final outgoingHandlers = incoming.outgoingHandlers;
      if (!outgoingHandlers.isConnected('Send Name')) {
        mySnackBar(context, outgoingHandlers.incomingState.serverError,
            outgoingHandlers.incomingState.clearServerError);
        return;
      }

      isNetworkPending.value = true;
      outgoingHandlers.sendMyName(
          incomingPersonId,
          Env.current.myAuthToken ?? 'AUTH_DISAPPEARED',
          nameInputCtrl.value.text,
          'YourName widget');

      // Unhandled Exception: A ValueNotifier<bool> was used after being disposed.
      // const timeoutSec = 3;
      // Future.delayed(const Duration(seconds: timeoutSec), () async {
      //   if (isNetworkPending.value == true) {
      //     isNetworkPending.value = false;
      //     mySnackBar(context,
      //         'No reply from backend within $timeoutSec seconds', null);
      //   }
      // });
    }

    final canSend = isNetworkPending.value == false
        // && nameInputCtrl.value.text.isNotEmpty
        ;

    final size = MediaQuery.of(context).size;
    return formDecorator(
      context,
      size,
      Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Text(
                "What is your name?",
                style: loginTitleStyle,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Row(children: [
              Expanded(
                  child: TextFormField(
                controller: nameInputCtrl,
                autofocus: true,
                focusNode: nameFocusNode,
                keyboardType: TextInputType.name,
                decoration: inputDeco("Your Name"),
              )),
            ]),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        canSend ? _handleSend : null, // null disables button
                    style: loginButtonStyle,
                    child: const Text(
                      'Continue',
                      style: loginButtonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
