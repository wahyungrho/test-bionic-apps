import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_bionic_app_2/controller/sign_in_controller.dart';
import 'package:test_bionic_app_2/theme.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController signInController = Get.put(SignInController());

    UserCredential? userCredential;

    Widget textEditing(String hintText, {bool? secureText}) => Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(bottom: defaultMargin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: greyColor)),
          child: Center(
            child: TextFormField(
                obscureText: secureText ?? false,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                )),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Obx(() => (!signInController.isLogin.value)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textEditing('Email'),
                  textEditing('Password', secureText: true),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {},
                          child: const Text('Sign In'))),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        userCredential =
                            await signInController.signInWithGoogle();

                        if (userCredential != null) {
                          signInController.getUserLogin(userCredential!);
                        }
                        debugPrint('$userCredential');
                      },
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Sign In with Google Account'),
                    ),
                  )
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Account Login'),
                    Text('Name : ${signInController.username.value}'),
                    Text('Email : ${signInController.email.value}'),
                    ElevatedButton(
                        onPressed: () async {
                          signInController.signout();
                        },
                        child: const Text('Logout'))
                  ],
                ),
              )),
      ),
    );
  }
}
