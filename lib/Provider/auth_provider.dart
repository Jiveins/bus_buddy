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

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String? cId;
  @override
  void dispose() {
    _name.dispose();
    _mail.dispose();
    _number.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  loginSubmit(BuildContext context) async {
    try {
      Map data = {
        "email": _mail.text,
        "password": _password.text,
      };
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
        notifyListeners();

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
}
