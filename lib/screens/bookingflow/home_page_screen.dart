import 'dart:convert';
import '../../utils/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:bus_buddy/screens/bookingflow/find_bus.dart';
import 'package:bus_buddy/model/routes.dart';
import 'package:bus_buddy/utils/appcolor.dart';
import 'package:bus_buddy/utils/global_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String? name;
  final String? mobile;
  final String? email;
  final String? cid;

  const HomePage({super.key, this.cid, this.name, this.email, this.mobile});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  String? name;
  String? mobile;
  String? email;
  TextEditingController datecontroller = TextEditingController();
  late SharedPreferences prefs;
  bool fieldsSelected = false;

  @override
  void initState() {
    super.initState();
    _stop();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  List<Routes> route = [];
  Routes? source;
  Routes? destination;

  void _stop() async {
    var response = await http.get(
      Uri.parse(AppUrls.getStops),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      route = data.map((e) => Routes.fromJson(e)).toList();
      debugPrint(response.body);
      setState(() {});
    }
  }

  void searchBuses() async {
    final res = await http.post(
        Uri.parse('https://busbooking.bestdevelopmentteam.com/Api/bussrch.php'),
        body: jsonEncode({
          "start": source?.name.toString(),
          "end": destination?.name.toString(),
          "date": datecontroller.text
        }),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
    if (res.statusCode == 200) {
      debugPrint(res.body);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Select Source & Destination !!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "CUTOMER ID ON HOME${GlobalFunction.userProfile.cid.toString()}");

    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: screensize.height,
          width: screensize.width,
          child: Stack(
            children: [
              Positioned(
                width: screensize.width,
                top: -1,
                bottom: 610,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Hey ${GlobalFunction.userProfile.name.toString()} !",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const Text(
                        'Where you want to go?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const Image(
                        image: AssetImage("assets/images/homepage.png"),
                        height: 120,
                        width: 120,
                      )
                    ],
                  ),
                ),
              ),

              //SERCH DESTIONAATION AND DATES
              Positioned(
                top: 160,
                bottom: 80,
                right: 15,
                left: 15,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.secondary,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurStyle: BlurStyle.normal,
                          blurRadius: 9,
                          offset: Offset(6, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 40),
                          child: DropdownButtonFormField(
                            hint: const Text("Boarding From",
                                style: TextStyle(
                                    fontFamily: "Ubuntu",
                                    fontWeight: FontWeight.w400)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(243, 238, 255,
                                  1), //background: rgba(243, 238, 255, 1);,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            borderRadius: BorderRadius.circular(5),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(181, 160, 232, 1),
                            ),
                            value: source,
                            items: route.map((e) {
                              return DropdownMenuItem<Routes>(
                                value: e,
                                child: Text(e.name.toString(),
                                    style: TextStyle(
                                        fontFamily: "Ubuntu",
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primary)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                source = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          child: DropdownButtonFormField(
                            hint: const Text("Where are you going?",
                                style: TextStyle(
                                  fontFamily: "Ubuntu",
                                  fontWeight: FontWeight.w400,
                                )),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(243, 238, 255,
                                  1), //background: rgba(243, 238, 255, 1);,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            borderRadius: BorderRadius.circular(5),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(181, 160, 232, 1),
                            ),
                            value: destination,
                            items: route.map((e) {
                              return DropdownMenuItem<Routes>(
                                value: e,
                                child: Text(e.name.toString(),
                                    style: TextStyle(
                                        fontFamily: "Ubuntu",
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primary)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                destination = value;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: SizedBox(
                                  height: 45,
                                  width: 250,
                                  child: TextField(
                                    // Date Select
                                    controller: datecontroller,
                                    readOnly: true,
                                    onTap: () async {
                                      final DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2050),
                                        keyboardType: TextInputType.datetime,
                                        builder: (context, child) {
                                          return Theme(
                                              data: Theme.of(context).copyWith(
                                                  cardColor:
                                                      AppColors.secondary,
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: AppColors.primary,
                                                    secondary:
                                                        AppColors.secondary,
                                                  )),
                                              child: child!);
                                        },
                                      );
                                      if (pickedDate != null) {
                                        debugPrint('$pickedDate');
                                        String formateDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        debugPrint(formateDate);
                                        setState(() {
                                          datecontroller.text = formateDate;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            margin: const EdgeInsets.only(
                                                bottom: 3, left: 10, right: 10),
                                            behavior: SnackBarBehavior.floating,
                                            content: const Text(
                                                "Please Select Date !!",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            backgroundColor:
                                                AppColors.secondary,
                                          ),
                                        );
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.secondary,
                                      isDense: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: AppColors.primary),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primary),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primary),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primary),
                                      ),
                                      // prefixIcon: Icon(Icons.date_range, color: AppColors.primary),
                                      prefixIcon: Icon(
                                          Icons.calendar_month_outlined,
                                          color: AppColors.primary),
                                      labelText: "Day*",
                                      hintText: "Select Date",
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 293,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                if (source == null ||
                                    destination == null ||
                                    datecontroller.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      margin: const EdgeInsets.only(
                                          bottom: 3, right: 10, left: 10),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      content: const Text(
                                          "Please select source, destination, and date.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 15)),
                                      backgroundColor: AppColors.secondary,
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FindBus(
                                        source: source!.name.toString(),
                                        destination:
                                            destination!.name.toString(),
                                        datecontroller: datecontroller.text,
                                        cId: GlobalFunction.userProfile.cid
                                            .toString(),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Find Buses',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //UpComing Feature
              const Padding(
                padding: EdgeInsets.only(top: 530, left: 20),
                child:
                    Text("UpComing Features..", style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 560, left: 15),
                child: SizedBox(
                  height: 350,
                  child: ListView(children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              debugPrint('${AuthUrls.registration} ');
                            },
                            child: Card(
                              color: AppColors.primary,
                              child: SizedBox(
                                height: 140,
                                width: 288,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Stay updated with \nreal-time bus locations. \n\nNever miss your stop!",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Lottie.network(
                                            "https://lottie.host/68b773b8-dbd9-4fd3-8676-eb26ade732ef/8lmoFYgxmf.json",
                                            width: 120,
                                            height: 135),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: AppColors.primary,
                            child: Container(
                              height: 140,
                              width: 288,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Every Week \nnew offer !!",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Lottie.network(
                                          "https://lottie.host/5f710893-1046-4f75-ab97-d94164daa537/6To9UHjuBS.json",
                                          width: 190,
                                          height: 135),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: AppColors.primary,
                            child: Container(
                              height: 140,
                              width: 288,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Customer \nSupport!!",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Lottie.network(
                                          "https://lottie.host/a933251a-a92c-4393-822b-307bf71b0e8d/WabGNk43tW.json",
                                          width: 190,
                                          height: 135),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: AppColors.primary,
                            child: Container(
                              height: 140,
                              width: 288,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Secure \nPayment..",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Lottie.network(
                                          "https://lottie.host/d6b8d689-8031-426b-b778-bf61d1c5234b/xTtSknlMBN.json",
                                          width: 190,
                                          height: 135),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: AppColors.primary,
                            child: Container(
                              height: 140,
                              width: 288,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Loading... \nfeatures\nDon't\nmiss out..",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Lottie.network(
                                          "https://lottie.host/d92f4867-e6f5-43a7-9d42-1d3080fcece9/vphfGREsms.json",
                                          width: 190,
                                          height: 135),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
