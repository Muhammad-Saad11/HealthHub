import 'package:bgmfitness/extensions/stringCasingExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../ViewModels/customer_authentication.dart';
import '../google_login.dart';
import 'SellerPages/seller_sign_up.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                  "Create an Account",
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
                      buildFullName(),
                      SizedBox(height: 20.h),
                      buildEmail(),
                      SizedBox(height: 20.h),
                      buildPassword(),
                      SizedBox(height: 20.h),
                      buildSignUpButton(),
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
          'Become a Vendor,',
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
              MaterialPageRoute(builder: (context) => const VendorSignupPage()),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          child: Text(
            'Sign up!',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFullName() => TextFormField(
        decoration: kTextFieldDecoration.copyWith(
            prefixIcon: Icon(Icons.note_alt),
            hintText: "Enter your full name",
            labelText: "Full Name",
            labelStyle: TextStyle(color: Colors.black)),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please Enter Correct Name";
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => nameController.text = value!),
      );

  Column buildSignUpButton() {
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
                await customer_signup(
                    name: nameController.text.toTitleCase(),
                    email: emailController.text,
                    password: passController.text);

                Navigator.pushNamedAndRemoveUntil(
                    context, 'mainScreen', (route) => false);
              } catch (e) {
                setState(() {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                });
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text(
            "Sign up",
            style: TextStyle(
              fontFamily: 'SourceSansPro-Regular',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

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
            !RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&$*~]).{8,}$')
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

}
