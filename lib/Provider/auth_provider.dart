import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class AuthProvider with ChangeNotifier
{

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value)
  {
    _loading = value;
    notifyListeners();
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _Password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose()
  {
    _name.dispose();
    _mail.dispose();
    _number.dispose();
    _Password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void Login(BuildContext context) async
  {
    try
    {
      Map data =
      {
        "email" : _mail.text,
        "password" : _Password.text,
      };
      var response = await http.post(Uri.parse("https://busbooking.bestdevelopmentteam.com/Api/user_login"),
        body: jsonEncode(data),
        headers:
        {'Content-Type':"application/json; charset=UTF-8" },
      );
      print(response.body);
    }
    catch(e)
    {
      print(e);
    }
  }

  void Register(BuildContext context) async {
    // final url = Uri.parse("https://busbooking.bestdevelopmentteam.com/Api/user_registration");
    try
    {
      Map data =
      {
        "name" : _name.text,
        "mobile_no" : _number.text ,
        "email" : _mail.text,
        "password" : _Password.text,
      };
      var response = await http.post(
        Uri.parse("https://busbooking.bestdevelopmentteam.com/Api/user_registration"),
        body: jsonEncode(data),
        headers: {
          'Content-Type':"application/json; charset=UTF-8"
        },
      );
      print(response.body);
    }
    catch(e)
    {
      print(e);
    }
  }

}