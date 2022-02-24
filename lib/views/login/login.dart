// https://www.loginradius.com/blog/async/guest-post/authenticating-flutter-apps/

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env/env.dart';
import '../../network/incoming/incoming_state.dart';
import '../../utils/my_snack_bar.dart';
import '../../utils/theme.dart';
import '../home.dart';
import 'timer.dart';

class Login extends HookConsumerWidget {
  final Env env;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  const Login({required this.env, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerStateProvider);
    final incoming = ref.watch(incomingStateProvider);
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
    }, [codeTyped.text]);

    if (isNetworkPending.value == true && incoming.auth != null) {
      isNetworkPending.value = false;
      outgoingHandlers.sendLogin(incoming.auth!);
      // MySharedPreferences.setMyAuthToken(incoming.auth!);
      MaterialPageRoute(builder: (context) => const Home());
    }

    Future<void> _handleSendCode() async {
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

    if (isNetworkPending.value == true && incoming.needsCode != null) {
      isNetworkPending.value = false;
      isCodeSent.value =
          incoming.needsCode!.emailSent || incoming.needsCode!.smsSent;

      sentTo.value = incoming.sentTo_fromServerResponse;

      codeFocusNode.requestFocus();

      timer.startTimer(onExpired: () {
        emailFocusNode.requestFocus();
      }, onEachSecond: (int currentSecondsLeft) {
        if (currentSecondsLeft == 1) {
          codeFocusNode.requestFocus();
        }
      });

      // timer.notifyListeners(); // force re-render

      // String sentTo_fromServerResponse = '';
      // if (emailController.value.text.isNotEmpty) {
      //   sentTo_fromServerResponse += 'Email';
      // }
      // if (smsController.value.text.isNotEmpty) {
      //   if (sentTo_fromServerResponse.isNotEmpty) {
      //     sentTo_fromServerResponse += ' and ';
      //   }
      //   sentTo_fromServerResponse += 'SMS';
      // }
      // sentTo.value = sentTo_fromServerResponse;

      // isNetworkPending.value = true;
      // isCodeSent.value = false;
      // Future.delayed(const Duration(seconds: 3), () async {
      //   isNetworkPending.value = false;
      //   isCodeSent.value = true;
      // });

      // env.myAuthToken = 'accessToken';
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const Home()));
    }

    // final canSendCode = !(timer.isRunning || isNetworkPending.value == true);
    final canSendCode = !timer.isRunning;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: chatBackground,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Center(
          child: Container(
            width: size.width * 0.85,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: Text(
                      "Shared Shopping List",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  TextFormField(
                    // validator: (value) =>
                    //     Validator.validateEmail(value ?? ""),
                    controller: emailInputCtrl,
                    enabled: canSendCode,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDeco("Email"),
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFormField(
                    // validator: (value) =>
                    //     Validator.validatePhoneNumber(value ?? ""),
                    controller: smsInputCtrl,
                    enabled: canSendCode,
                    keyboardType: TextInputType.phone,
                    decoration: inputDeco("Phone"),
                  ),
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
                                ? 'Send code in ${timer.timeLeftFormatted}...'
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Home()));
                                  },
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
          ),
        ),
      ),
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

// ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   content: const Text('Checking your email/phone'),
//   backgroundColor: Colors.green.shade300,
// ));

// dynamic res = await _apiClient.person(
//   emailController.text,
//   passwordController.text,
// );
// ScaffoldMessenger.of(context).hideCurrentSnackBar();

//if there is no error, get the person's accesstoken and pass it to HomeScreen
// if (res['ErrorCode'] == null) {
//   String accessToken = res['access_token'];
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => Home(accesstoken: accessToken)));
// } else {
//   //if an error occurs, show snackbar with error message
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text('Error: ${res['Message']}'),
//     backgroundColor: Colors.red.shade300,
//   ));
// }
