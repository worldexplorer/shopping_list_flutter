// https://www.loginradius.com/blog/async/guest-post/authenticating-flutter-apps/

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../env/env.dart';
import 'login.dart';

class Register extends HookConsumerWidget {
  final Env env;

  const Register({required this.env, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    Future<void> _handleRegister() async {
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
          "Password": passwordController.text,
          "About": 'I am a new user :smile:',
          "FirstName": "Test",
          "LastName": "Account",
          "BirthDate": "10-12-1985",
          "Gender": "M",
        };

        //get response from ApiClient
        // dynamic res = await _apiClient.registerUser(userData);
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

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login(env: env)));
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
                        "Register",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    TextFormField(
                      validator: (value) => EmailValidator.validate(value ?? '')
                          ? null
                          : "Please enter a valid email",
                      controller: emailController,
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
                      // obscureText: _showPassword,
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
                    SizedBox(height: size.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleRegister,
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15)),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class Validator {
  static String? validatePassword(String s) {
    return null;
  }
}
