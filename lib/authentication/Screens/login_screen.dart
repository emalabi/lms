import 'package:flutter/material.dart';
import 'package:lms/authentication/Screens/signup_screen.dart';
import 'package:lms/constants/constants.dart';
import 'package:lms/constants/extension.dart';
import 'package:lms/constants/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants/colors.dart';
import '../auth.dart';

class SignIn extends StatefulWidget {
  static const String id = 'signin_screen';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _spinner = false;
  final bool login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: ModalProgressHUD(
            inAsyncCall: _spinner,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Expanded(
                        child: TextFormField(
                          key: ValueKey('email'),
                          autocorrect: false,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isValidEmail) {
                              return null;
                            } else {
                              return 'Please, enter a valid email';
                            }
                          },
                          decoration: kInputTextFieldDecoration.copyWith(
                              labelText: 'Email'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Expanded(
                        child: TextFormField(
                          key: ValueKey('password'),
                          autocorrect: false,
                          controller: _passwordController,
                          obscureText: _isHidden,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.length >= 8) {
                              return null;
                            } else {
                              return 'Password should not be less than 8 characters ';
                            }
                          },
                          decoration: kInputTextFieldDecoration.copyWith(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isHidden = !_isHidden;
                                });
                              },
                              child: Icon(_isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(right: 16.0, left: 16.0),
                      child: RoundedButton(
                        // onPressed: () async {
                        //   if (_formKey.currentState.validate()) {
                        //     setState(() {
                        //       _spinner = true;
                        //     });
                        //   } else {
                        //     setState(() {
                        //       _spinner = false;
                        //     });
                        //   }
                        //   final user = await FirebaseAuth.instance
                        //       .signInWithEmailAndPassword(
                        //           email: _emailController.text,
                        //           password: _passwordController.text);
                        //   try {
                        //     if (user != null) {
                        //       Navigator.pushNamed(context, SplashScreen.id);
                        //     }
                        //     setState(() {
                        //       _spinner = false;
                        //     });
                        //   } catch (e) {
                        //     var snackbar = SnackBar(
                        //         content: Text(
                        //       e.toString(),
                        //     ));
                        //     ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        //     setState(() {
                        //       _spinner = false;
                        //     });
                        //   }
                        // },
                        onPressed: () => _signInUser(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text),
                        title: 'SIGN IN',
                        colour: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          login
                              ? "Don’t have an Account ? "
                              : "Already have an Account ? ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUp();
                                },
                              ),
                            );
                          },
                          child: Text(
                            login ? "Sign Up" : "Sign In",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
      // ),
    );
  }

  void _signInUser({
    String email,
    String password,
    BuildContext context,
  }) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _spinner = true;
      });
    } else {
      setState(() {
        _spinner = false;
      });
    }
    try {
      String signIn = await Auth().loginUserWithEmail(
        email: email,
        password: password,
      );
      if (signIn == 'success') {
        setState(() {
          _spinner = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          _spinner = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(signIn),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {}
  }
}
