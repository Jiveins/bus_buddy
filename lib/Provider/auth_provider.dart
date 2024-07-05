import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/login.dart';
import '../Auth/verify_mail.dart';
import '../screens/bottombar_screen.dart';
import '../screens/splash_screen.dart';
import '../utils/app_urls.dart';
import '../utils/appcolor.dart';

class AuthProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String? cId;
  @override
  void dispose() {
    nameController.dispose();
    mailController.dispose();
    numberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  loginSubmit(BuildContext context) async {
    try {
      Map data = {
        "email": mailController.text,
        "password": passwordController.text,
      };
      print('Body:::${data}');
      var response = await http.post(
        Uri.parse(AuthUrls.login),
        body: jsonEncode(data),
        headers: {'Content-Type': "application/json; charset=UTF-8"},
      );
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      var responseBody = jsonDecode(response.body);
      if (responseBody['STATUS'] == true) {
        cId = responseBody['cid'];

        var shredPref = await SharedPreferences.getInstance();
        shredPref.setString(UiScreenState.keylogin, responseBody['cid']);
        debugPrint("DATATA OF PREDFS:$shredPref");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottoBar(
              cId: responseBody['cid'],
            ),
          ),
        );
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['message'],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            showCloseIcon: true,
            elevation: 6,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: AppColors.secondary,
          ),
        );
        // debugPrint('CUSTOMER ID::::$cId');
      } else if (responseBody['STATUS'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                responseBody['message'],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            showCloseIcon: true,
            elevation: 6,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: AppColors.secondary,
          ),
        );
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

   registerUser(BuildContext context) async {
    if (nameController.text.isEmpty ||
        numberController.text.isEmpty ||
        mailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
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
        "name": nameController.text,
        "mobile_no": numberController.text,
        "email": mailController.text,
        "password": passwordController.text,
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
        notifyListeners();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyMail(email: mailController.text),
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
}
