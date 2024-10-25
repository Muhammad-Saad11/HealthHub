import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150.h),
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lora"),
                  ),
                  SizedBox(height: 19.h),
                  Text("Don\'t worry.", style: TextStyle(fontSize: 16.sp)),
                  Text(
                      "Enter your email we\'ll send you a verification code to reset your password",
                      style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 50.h),
                  Text("Email", style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 6.h),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        buildShowAlert(),
                        buildEmail(),
                        SizedBox(
                          height: 20.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                print(emailController.text);
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: emailController.text);
                                await ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                            "Check Your Email. A Password Reset Link has sent to Your Email")));
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'mainScreen', (route) => false);
                              } catch (e) {
                                setState(() {
                                  error = e.toString();
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 50.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                color: Colors.black),
                            child: Center(
                                child: Text(
                              "Send",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmail() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: kTextFieldDecoration.copyWith(
            labelStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(Icons.email),
            hintText: "Enter your Email"),
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
}
