import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/appcolor.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Setting",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  child: Image.asset(
                "assets/images/setting_new.png",
                height: 227,
                width: 250,
              )),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              color: AppColors.secondary,
              child: ListTile(
                title: Text("App language"),
                subtitle: Text("English\t(Device language)"),
                trailing: Icon(Icons.language_outlined, size: 30),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Card(
              color: AppColors.secondary,
              child: ListTile(
                title: Text("Help Center"),
                subtitle: Text("Contact us,Privacy Policy"),
                trailing: Icon(CupertinoIcons.question_circle_fill, size: 30),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Card(
              color: AppColors.secondary,
              child: ListTile(
                title: Text("Invite a friend"),
                trailing: Icon(CupertinoIcons.person_3_fill, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
