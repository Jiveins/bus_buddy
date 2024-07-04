import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'bottombar_screen.dart';
import '../../Auth/login.dart';
import '../../utils/appcolor.dart';

class UiScreen extends StatefulWidget {
  const UiScreen({super.key});

  @override
  State<UiScreen> createState() => UiScreenState();
}

class UiScreenState extends State<UiScreen> {
  static const String keylogin = "Login";

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                children: [
                  Image.asset("assets/images/feature/BusBuddy-logo.png"),
                  const Text(
                    "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tWhere Every Journey Begins !!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Lottie.network(
                "https://lottie.host/633f562b-a236-40b5-b655-07c97fdb4190/PYgUEWoKLZ.json",
                height: 280),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Image.asset("assets/images/feature/splash_image.png"),
            ),
          ],
        ),
      ),
    );
  }

  void whereToGo() async {
    var sheredPref = await SharedPreferences.getInstance();
    String? islogin = sheredPref.getString(keylogin);
    print("You are login to nacho ab!! $islogin");
    Timer(const Duration(seconds: 5), () {
      if (islogin != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottoBar(
                cId: islogin,
              ),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LogIn(),
            ));
      }
    });
  }
}
