// https://www.loginradius.com/blog/async/guest-post/authenticating-flutter-apps/

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env/env.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/my_shared_preferences.dart';
import '../../utils/my_snack_bar.dart';
import '../../utils/theme.dart';
import '../router.dart';
import 'timer.dart';

class Login extends HookConsumerWidget {
  static final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: 'Login');

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerStateProvider);
    final router = ref.watch(routerProvider);

    final incoming = ref.watch(incomingStateProvider);
    mySnackBar(context, incoming.serverError, incoming.clearServerError);
    mySnackBar(context, incoming.clientError, incoming.clearClientError);

    final outgoingHandlers = incoming.outgoingHandlers;

    final emailFocusNode = useFocusNode(
      debugLabel: 'emailFocusNode',
    );

    final codeFocusNode = useFocusNode(
      debugLabel: 'codeFocusNode',
    );

    final emailInputCtrl =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final smsInputCtrl = useTextEditingController(text: '');

    final isNetworkPending = useState(false);
    final isCodeSent = useState(false);

    final sentTo = useState('');
    final codeInputCtrl = useTextEditingController();

    final codeTyped = useValueListenable(codeInputCtrl);
    useEffect(() {
      final codeParsed = int.tryParse(codeTyped.text) ?? 0;
      if (codeTyped.text.length == 6 && codeParsed > 0) {
        isNetworkPending.value = true;
        outgoingHandlers.sendRegisterConfirm(
            emailInputCtrl.value.text, smsInputCtrl.value.text, codeParsed);
      }
      if (codeTyped.text.isEmpty && !timer.isRunning) {
        // enable 'Try as Anonymous' button
        isCodeSent.value = false;
      }
      return null;
    }, [codeTyped.text]);

    if (incoming.auth != null) {
      final auth = incoming.auth!;
      Future.delayed(const Duration(milliseconds: 200), () async {
        incoming.auth = null;
        Navigator.pushNamed(context, router.rooms.path);
      });

      timer.stopTimer();
      outgoingHandlers.sendLogin(auth);
      Env.current.myAuthToken = auth;

      isNetworkPending.value = false;
      MySharedPreferences.setMyAuthToken(auth);
    }

    _handleSendCode() async {
      if (_formKey.currentState!.validate() == false) {
        return;
      }

      if (!outgoingHandlers.isConnected('Send Code')) {
        mySnackBar(context, outgoingHandlers.incomingState.serverError,
            outgoingHandlers.incomingState.clearServerError);
        return;
      }

      isNetworkPending.value = true;
      outgoingHandlers.sendRegister(
          emailInputCtrl.value.text, smsInputCtrl.value.text);

      const timeoutSec = 3;
      Future.delayed(const Duration(seconds: timeoutSec), () async {
        if (isNetworkPending.value == true) {
          isNetworkPending.value = false;
          mySnackBar(context,
              'No reply from backend within $timeoutSec seconds', null);
        }
      });
    }

    _handleTryAnonymous() {
      timer.stopTimer();
      Env.current.myAuthToken = anonymousAuthToken;
      outgoingHandlers.sendLogin(anonymousAuthToken);
      Navigator.pushNamed(context, router.rooms.path);
    }

    if (isNetworkPending.value == true && incoming.needsCode != null) {
      isNetworkPending.value = false;
      isCodeSent.value =
          incoming.needsCode!.emailSent || incoming.needsCode!.smsSent;

      sentTo.value = incoming.sentTo_fromServerResponse;

      if (isCodeSent.value) {
        codeFocusNode.requestFocus();
      }

      timer.startTimer(onExpired: () {
        emailFocusNode.requestFocus();
        incoming.needsCode = null;
      }, onEachSecond: (int currentSecondsLeft) {
        if (currentSecondsLeft == 1) {
          if (isCodeSent.value) {
            codeFocusNode.requestFocus();
          }
        }
      });
    }

    // final canSendCode = !(timer.isRunning || isNetworkPending.value == true);
    final canSendCode = !timer.isRunning;

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
                "Shared Shopping List",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Row(children: [
              Expanded(
                  child: TextFormField(
                // validator: (value) =>
                //     Validator.validateEmail(value ?? ""),
                controller: emailInputCtrl,
                enabled: canSendCode,
                autofocus: true,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDeco("Email"),
              )),
              // incoming.needsCode != null
              //     ? (emailInputCtrl.text.isNotEmpty &&
              //             incoming.needsCode!.emailSent
              //         ? const Icon(Icons.check, color: Colors.green, size: 26)
              //         : const Icon(Icons.cancel, color: Colors.red, size: 26))
              //     : const SizedBox(),
            ]),
            SizedBox(height: size.height * 0.03),
            Row(children: [
              Expanded(
                child: TextFormField(
                  // validator: (value) =>
                  //     Validator.validatePhoneNumber(value ?? ""),
                  controller: smsInputCtrl,
                  enabled: canSendCode,
                  keyboardType: TextInputType.phone,
                  decoration: inputDeco("Phone"),
                ),
              ),
              // incoming.needsCode != null
              //     ? (emailInputCtrl.text.isNotEmpty &&
              //             incoming.needsCode!.emailSent
              //         ? const Icon(Icons.check, color: Colors.green, size: 26)
              //         : const Icon(Icons.cancel, color: Colors.red, size: 26))
              //     : const SizedBox(),
            ]),
            SizedBox(height: size.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: canSendCode ? _handleSendCode : null,
                    style: loginButtonStyle,
                    child: Text(
                      timer.isRunning
                          ? (isCodeSent.value ? 'Code sent ' : 'Not sent ') +
                              '${timer.timeLeftFormatted}...'
                          : 'Send 6-digit code',
                      style: loginButtonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
            ...(isCodeSent.value
                ? [
                    TextFormField(
                      controller: codeInputCtrl,
                      focusNode: codeFocusNode,
                      enabled: !isNetworkPending.value,
                      // validator: (value) =>
                      //     Validator.validateNumber(value ?? ""),
                      keyboardType: TextInputType.number,
                      decoration: inputDeco(incoming.needsCode != null
                          ? incoming.needsCode!.status
                          : 'Check your ${sentTo.value}'),
                    ),
                  ]
                : [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleTryAnonymous,
                            style: loginButtonStyle,
                            child: const Text(
                              "Try as Anonymous",
                              style: loginButtonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
          ],
        ),
      ),
    );
  }

  Widget formDecorator(BuildContext context, Size size, Widget form) {
    return Scaffold(
      backgroundColor: chatBackground,
      body:
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const Log(showAppBar: true)));
          //   },
          //   child:
          Center(
        child: Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(child: form),
        ),
      ),
      // )
    );
  }

  InputDecoration inputDeco(hintText) {
    return InputDecoration(
        hintText: hintText,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ));
  }
}
