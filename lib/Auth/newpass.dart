
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/appcolor.dart';
import 'successful.dart';

class NewPass extends StatefulWidget {
  final String email;

  const NewPass({super.key, required this.email});

  @override
  State<NewPass> createState() => _NewPassState();
}

class _NewPassState extends State<NewPass> {
  final _formKey = GlobalKey<FormState>();
  bool _passVisible = false;
  bool _cpassVisible = false;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _comPass = TextEditingController();

  void confirmPass() async {
    try {
      var response = await http.post(
          Uri.parse("https://busbooking.bestdevelopmentteam.com/Api/newpwd"),
          body: jsonEncode(
              {'email': widget.email.toString(), "password": _pass.text}),
          headers: {'content-type': 'application/json; charset=UTF-8'});
      if (response.statusCode == 200) {
        debugPrint(response.body);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Done()));
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.email);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Verify Your Email",
          style: TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      //background: rgba(255, 98, 96, 1);
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/auth/forgot.png",
                  height: 224,
                  width: 300,
                ),
                const SizedBox(height: 40),
                Text(
                  "Set the new password for account so \nyou can login and access all  features.",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  // Password
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: !_passVisible,
                  controller: _pass,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondary,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    prefixIcon: Icon(
                      Icons.password,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    labelText: "New Password*",
                    hintText: "New Password",
                    suffixIcon: IconButton(
                      icon: Icon(_passVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passVisible = !_passVisible;
                        });
                      },
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    // Regular expression pattern to validate password format
                    if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*]).{6,}$')
                        .hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter, one lowercase letter, one number, one special character, and be at least 6 characters long';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  // For Confirm Password
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: !_cpassVisible,
                  controller: _comPass,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondary,
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondary),
                    ),
                    labelText: "Confirm Password*",
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(
                      Icons.password,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_cpassVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _cpassVisible = !_cpassVisible;
                        });
                      },
                    ),
                  ),
                  validator: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      if (value != _pass.text) {
                        return 'Passwords do not match';
                      }
                    } else {
                      return 'Please enter your password again';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Validate the form
                      confirmPass(); // Submit the login
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
                          "Save",
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
