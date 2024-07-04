import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/appcolor.dart';
import 'registration.dart';
import 'verify_otp.dart';


class ForgotPass extends StatefulWidget {
  // const ForgotPass({super.key});
  const ForgotPass({super.key});
  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mail = TextEditingController();

  @override
  void dispose() {
    _mail.dispose();
    super.dispose();
  }

  Future forgotPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        var response = await http.post(
          Uri.parse(
              "https://busbooking.bestdevelopmentteam.com/Api/forgetpwd.php"),
          body: jsonEncode({"email": _mail.text}),
          headers: {'Content-Type': "application/json; charset=UTF-8"},
        );
        debugPrint('Response status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        var responseBody = jsonDecode(response.body);
        if (responseBody['STATUS'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent and It will be expire in 2 Minutes !!'),
              duration: Duration(seconds: 5),
              elevation: 10,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 50),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtp(email: _mail.text),
            ),
          );
        } else if (responseBody['STATUS'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User not registered. Please register first !!.'),
              duration: Duration(seconds: 5),
              elevation: 10,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 50),
            ),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Registration(),
              ));
        }
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Forgot Password",
          style: TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/auth/forgot.png",
                  height: 224,
                  width: 300,
                ),
                const SizedBox(height: 40),
                Text(
                  "Please enter your E-mail to \n receive a verification code !!",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextFormField(
                    // E-Mail
                    controller: _mail,
                    decoration: InputDecoration(
                        labelText: "E-mail*",
                        hintText: "E-Mail",
                        filled: true,
                        fillColor: AppColors.secondary,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.mail,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary),
                        )),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value) ||
                          !value.contains("@gmail.com")) {
                        return 'Format is abc123@gmail.com';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Validate the form
                      forgotPassword(context); // Submit the login
                    } else {
                      // Show a Snackbar indicating that the form fields are not valid
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill proper mail addrerss.."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      // width: 250,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Send",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
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
}
