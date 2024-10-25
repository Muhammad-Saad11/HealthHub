import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';
import '../../../google_login.dart';
import '../../Models/vendor_signup.dart';
import '../../ViewModels/vendor_authentication.dart';

class VendorSignupPage extends StatefulWidget {
  const VendorSignupPage({super.key});

  @override
  State<VendorSignupPage> createState() => _VendorSignupPageState();
}

class _VendorSignupPageState extends State<VendorSignupPage> {
  Vendor vendor = Vendor();
  final formKey = GlobalKey<FormState>();
  String? error;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusNode focus = FocusScope.of(context);
        if(!focus.hasPrimaryFocus){
          focus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                    width: 150.w,
                    height: 150.h,
                    child: Image.asset("assets/logo.png")
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 10.h),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 5.h),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 40.w, vertical: 10.h),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        buildFullName(),
                        SizedBox(height: 16.h),
                        buildEmail(),
                        SizedBox(height: 16.h),
                        buildBusinessName(),
                        SizedBox(height: 16.h),
                        buildPassword(),
                        SizedBox(height: 16.h),
                        buildCNIC(),
                        SizedBox(height: 16.h),
                        buildNumber(),
                        SizedBox(height: 16.h),
                        buildAddress(),
                        SizedBox(height: 16.h),
                        buildSignUp_Button(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }





  Widget buildFullName() => TextFormField(
    decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(Icons.note_alt),
        hintText: "Enter your full name",
        labelText: "Full Name",
        labelStyle: TextStyle(
            color: Colors.black
        )
    ),
    validator: (value) {
      if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
        return "Please Enter Correct Name";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => vendor.name = value!),
  );

  Widget buildCNIC() => TextFormField(
    keyboardType: TextInputType.number,
    maxLength: 13,
    decoration: kTextFieldDecoration.copyWith(
        counterText: "",
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.badge),
        hintText: "Enter your CNIC Number", labelText: "CNIC"),
    validator: (value) {
      if (value!.isEmpty ||
          !RegExp(r'^\d{5}-\d{7}-\d{1}$|^\d{13}$').hasMatch(value)) {
        return "Please Enter Correct CNIC";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => vendor.cnic = value!),
  );

  Widget buildNumber() => TextFormField(
    keyboardType: TextInputType.number,
    maxLength: 11,
    decoration: kTextFieldDecoration.copyWith(
        counterText: "",
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.phone),
        hintText: "03xxxxxxxx", labelText: "Number"),
    validator: (value) {
      if (value!.isEmpty || !RegExp(r'^\d{11}$').hasMatch(value)) {
        return "Please Enter Correct Phone Number";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => vendor.number = value!),
  );

  Widget buildBusinessName() => TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: kTextFieldDecoration.copyWith(
      labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.business_center),
        hintText: "Enter your Business Name", labelText: "Business Name"),
    validator: (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[a-zA-Z0-9\s]{1,100}$').hasMatch(value)) {
        return "Please Enter Correct Business Name";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => vendor.businessName = value!),
  );

  Widget buildAddress() => TextFormField(
    decoration: kTextFieldDecoration.copyWith(
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.location_on),
        hintText: "Enter your Address", labelText: "Address"),
    validator: (value) {
      if (value!.isEmpty ||
          !RegExp(r"^[a-zA-Z0-9\s\-\.,#]+$").hasMatch(value)) {
        return "Please Enter Correct Address";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => vendor.address = value!),
  );

  Widget buildSignUp_Button() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            try{
              await vendorSignup(
                  name: vendor.name,
                  email: vendor.email,
                  businessName: vendor.businessName,
                  password: vendor.password,
                  cnic: vendor.cnic,
                  number: vendor.number,
                  address: vendor.address);

              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
              Navigator.pushNamedAndRemoveUntil(
                  context, 'mainScreen', (route) => false);
            }
            catch(e){
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Oops something went wrong!")));
            }

          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: Text(
          "Sign up",
          style: TextStyle(
            fontFamily: 'SourceSansPro-Regular',
            color: Colors.white,
          ),
        ),
      ),
    ],
  );

  Widget buildEmail() => TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: kTextFieldDecoration.copyWith(
        prefixIcon: Icon(Icons.email),
        labelStyle: TextStyle(
            color: Colors.black
        ),
        hintText: "Enter your Email", labelText: "Email"),
    validator: (value) {
      if (value!.isEmpty ||
          !RegExp(r"^[a-zA-Z][a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]*@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
        return "Enter Correct Email";
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => vendor.email = value!),
  );

  Widget buildPassword() => TextFormField(
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: kTextFieldDecoration.copyWith(
          prefixIcon: Icon(Icons.lock),
          labelStyle: TextStyle(
              color: Colors.black
          ),
          hintText: "Enter your Password", labelText: "Password"),
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
      onSaved: (value) => setState(() => vendor.password = value!));

}
