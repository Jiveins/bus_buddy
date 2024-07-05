import 'dart:convert';
import 'package:bus_buddy/utils/app_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'bookingflow/home_page_screen.dart';
import 'profileScreens/profile_screen.dart';
import 'history/ticket_history_screen.dart';
import '../../model/userprofile.dart';
import '../../utils/appcolor.dart';
import '../../utils/global_function.dart';

class BottoBar extends StatefulWidget {
  final String? cId;

  const BottoBar({super.key, this.cId});

  @override
  State<BottoBar> createState() => _BottoBarState();
}

class _BottoBarState extends State<BottoBar> {
  String? name;
  String? mobile;
  String? email;

  int currentPageIndex = 0;
  displayName() async {
    final response = await http.post(Uri.parse(AppUrls.profile),
        body: jsonEncode({
          "cid": widget.cId.toString(),
        }));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      GlobalFunction.userProfile = UserProfile.fromJson(data['userProfile']);
      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    displayName();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('CUSTOMER ID BOTTOMBAR:::${widget.cId}');
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          HomePage(
            cid: widget.cId.toString(),
            name: name.toString(),
            email: email.toString(),
            mobile: mobile.toString(),
          ),
          TicketHistory(
            cId: widget.cId.toString(),
          ),
          Profile(
            cId: widget.cId,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentIndex: currentPageIndex,
        selectedItemColor: AppColors.primary,
        selectedFontSize: 12,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 14,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.home),
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.tickets),
            icon: Icon(CupertinoIcons.ticket),
            label: "My Booking",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.profile_circled),
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
