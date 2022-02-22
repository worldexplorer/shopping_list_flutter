// https://www.loginradius.com/blog/async/guest-post/authenticating-flutter-apps/

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env/env.dart';
import '../home.dart';
import 'register.dart';
import 'reset.dart';
import 'validator.dart';

class Login extends HookConsumerWidget {
  final Env env;

  const Login({required this.env, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    final emailController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');

    Future<void> _handleLogin() async {
      if (_formKey.currentState!.validate()) {
        //show snackbar to indicate loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Processing Data'),
          backgroundColor: Colors.green.shade300,
        ));

        //get response from ApiClient
        // dynamic res = await _apiClient.login(
        //   emailController.text,
        //   passwordController.text,
        // );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        //if there is no error, get the user's accesstoken and pass it to HomeScreen
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

        env.myAuthToken = 'accessToken';
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
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
                        "Login",
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
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      obscureText: true,
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Reset(env: env)));
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: size.height * 0.01),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: const Text(
                          'Anonymous',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15)),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
