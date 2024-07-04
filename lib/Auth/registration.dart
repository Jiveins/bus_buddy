import 'dart:convert';
import 'package:bus_buddy/Auth/login.dart';
import 'package:bus_buddy/Auth/verify_mail.dart';
import 'package:bus_buddy/utils/app_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  bool _passVisible = false;
  bool _cpassVisible = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _mail.dispose();
    _number.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void registerUser(BuildContext context) async {
    if (_name.text.isEmpty ||
        _number.text.isEmpty ||
        _mail.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      // Display snackbar if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are compulsory'),
        ),
      );
      return;
    }
    try {
      Map mapdata = {
        "name": _name.text,
        "mobile_no": _number.text,
        "email": _mail.text,
        "password": _password.text,
      };
      var response = await http.post(
        Uri.parse(AuthUrls.registration),
        body: jsonEncode(mapdata),
        headers: {'Content-Type': "application/json; charset=UTF-8"},
      );
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      var responseBody = jsonDecode(response.body);
      if (responseBody['STATUS'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Otp sent Sucessfully!!'),
            duration: Duration(seconds: 5),
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 50),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyMail(email: _mail.text),
          ),
        );
      } else if (responseBody['STATUS'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User already registered!!.'),
            duration: Duration(seconds: 5),
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 50),
          ),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LogIn(),
            ));
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: const Color.fromRGBO(255, 98, 96, 1),//background: rgba(255, 98, 96, 1);

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {});
            },
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Image(
                  image: AssetImage("assets/images/registration_new.jpg"),
                  height: 233,
                  width: 390,
                ),
                Text("Hop on Board : Your Journey Begins with Us !!",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AppColors.primary)),
                const SizedBox(
                  height: 45,
                ),
                TextFormField(
                  // For Name
                  controller: _name,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.secondary,
                      isDense: true,
                      labelText: "Name*",
                      prefixIcon: Icon(
                        CupertinoIcons.person_alt_circle,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      hintText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                      )),
                  keyboardType: TextInputType.name,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return (RegExp(r'[!@#%^&*0-9]').hasMatch(value))
                        ? 'Please enter alphabets only'
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  //For Number
                  controller: _number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.secondary,
                      isDense: true,
                      labelText: "Number*",
                      hintText: 'Number',
                      prefixIcon: Icon(
                        CupertinoIcons.phone,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.secondary),
                      )),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Number is required';
                    }
                    return (RegExp(r'[.!@#%^&*a-zA-Z]').hasMatch(value))
                        ? 'Enter only numbers'
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 5),
                TextFormField(
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
                        .hasMatch(value)) {
                      return 'Format is abc123@gmail.com';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  // Password
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: !_passVisible,
                  controller: _password,
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
                    labelText: "Password*",
                    hintText: "Password",
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
                const SizedBox(height: 25),
                TextFormField(
                  // For Confirm Password
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: !_cpassVisible,
                  controller: _confirmPassword,
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
                      if (value != _password.text) {
                        return 'Passwords do not match';
                      }
                    } else {
                      return 'Please enter your password again';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Validate the form
                        registerUser(context); // Submit the login
                      } else {
                        // Show a Snackbar indicating that the form fields are not valid
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please fill in all the fields with valid data"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
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
                            "Register",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already Account?"),
                    TextButton(
                      child: Text(
                        "LogIn Here",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LogIn(),
                        ));
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                            "By Clicking on Register, you are agree to "
                            "\n"
                            "Privacy Policy and "
                            "Terms & Conditions !!",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500)),
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
}
