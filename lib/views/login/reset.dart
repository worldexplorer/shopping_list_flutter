// https://www.loginradius.com/blog/async/guest-post/authenticating-flutter-apps/

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env/env.dart';
import 'register.dart';
import 'validator.dart';

class Reset extends HookConsumerWidget {
  final Env env;

  const Reset({required this.env, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    final emailController = useTextEditingController();
    final oneTimeCodeController = useTextEditingController();

    final codeSent = useState(false);

    Future<void> _handleReset() async {
      if (_formKey.currentState!.validate()) {
        //show snackbar to indicate loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Processing Data'),
          backgroundColor: Colors.green.shade300,
        ));

        //the user data to be sent
        Map<String, dynamic> userData = {
          "Email": [
            {
              "Type": "Primary",
              "Value": emailController.text,
            }
          ],
          "Password": oneTimeCodeController.text,
          "About": 'I am a new user :smile:',
          "FirstName": "Test",
          "LastName": "Account",
          "BirthDate": "10-12-1985",
          "Gender": "M",
        };

        //get response from ApiClient
        // dynamic res = await _apiClient.ResetUser(userData);
        await Future.delayed(const Duration(seconds: 2));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        //checks if there is no error in the response body.
        //if error is not present, navigate the users to Login Screen.
        // if (res['ErrorCode'] == null) {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => const LoginScreen()));
        // } else {
        //   //if error is present, display a snackbar showing the error messsage
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text('Error: ${res['Message']}'),
        //     backgroundColor: Colors.red.shade300,
        //   ));
        // }

        codeSent.value = true;
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.center,
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
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    TextFormField(
                      validator: (value) =>
                          Validator.validateEmail(value ?? ""),
                      controller: emailController,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleReset,
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15)),
                            child: Text(
                              codeSent.value
                                  ? "Send Again"
                                  : "Send 4-digit code",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...(codeSent.value
                        ? [
                            SizedBox(height: size.height * 0.05),
                            TextFormField(
                              validator: (value) =>
                                  Validator.validateEmail(value ?? ""),
                              controller: oneTimeCodeController,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "4-digit code",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _handleReset,
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.indigo,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15)),
                                    child: const Text(
                                      "Log in",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                        : []),
                    SizedBox(height: size.height * 0.04),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //forgot password screen
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: size.height * 0.02),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      const Text(
                        'Do not have an account?',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register(env: env)));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
