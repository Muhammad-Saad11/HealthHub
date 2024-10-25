import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../google_login.dart';
import '../Models/login_model.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? error;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusNode focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus) {
          focus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Image.asset("assets/logo.png")),
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontFamily: 'SourceSansPro-SemiBold',
                    fontSize: 35.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Text(
                  "Please enter your details.",
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                  child: Column(
                    children: [
                      buildShowAlert(),
                      buildEmail(),
                      SizedBox(height: 20.h),
                      buildPassword(),
                      buildForgotPass(),
                      buildSignInButton(),
                      SizedBox(height: 5.h),
                      buildBottomText(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildBottomText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontFamily: 'SourceSansPro-Regular',
            fontSize: 15.sp,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          child: Text(
            'Sign up!',
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  buildShowAlert() {
    if (error != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Text(
          "Invalid email or password $error",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox();
  }

  Widget buildFullName() => TextFormField(
        decoration: kTextFieldDecoration.copyWith(
            hintText: "Enter your full name", labelText: "Full Name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please Enter Correct Name";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => nameController.text = value!),
      );

  Widget buildEmail() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: kTextFieldDecoration.copyWith(
            prefixIcon: Icon(Icons.email),
            labelStyle: TextStyle(color: Colors.black),
            hintText: "Enter your Email",
            labelText: "Email"),
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r"^[a-zA-Z][a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]*@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
            return "Enter Correct Email";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => emailController.text = value!),
      );

  Widget buildPassword() => TextFormField(
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(
          prefixIcon: Icon(Icons.lock),
          labelStyle: TextStyle(color: Colors.black),
          hintText: "Enter your Password",
          labelText: "Password"),
      validator: (value) {
        if (value!.isEmpty ||
            !RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$')
                .hasMatch(value)) {
          return "Password must have "
              "\nlower case letters"
              "\nat least one digit"
              "\nat least one Special character";
        } else {
          return null;
        }
      },
      onSaved: (value) => setState(() => passController.text = value!));

  Align buildForgotPass() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
        child: Text(
          "Forgot Password?",
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14.sp,
              fontFamily: 'SourceSansPro-Regular'),
        ),
      ),
    );
  }


  Column buildSignInButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              try {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                await LoginScreenModel().signInWithEmailAndPassword(
                    email: emailController.text, password: passController.text);
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text(
            "Sign in",
            style: TextStyle(
              fontFamily: 'SourceSansPro-Regular',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
