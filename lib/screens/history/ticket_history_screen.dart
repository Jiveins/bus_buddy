import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/global_function.dart';
// import 'package:dotted_line/dotted_line.dart';
import '../../model/tickethistorymodel.dart';
import 'package:intl/intl.dart';
import '../../utils/appcolor.dart';

class TicketHistory extends StatefulWidget {
  final String? cId;

  const TicketHistory({super.key, this.cId});

  @override
  State<TicketHistory> createState() => _TicketHistoryState();
}

class _TicketHistoryState extends State<TicketHistory> {
  TextEditingController datecontroller = TextEditingController();
  Future<List<TicketHistoryM>> getTicketHistory() async {
    var body = {
      "cid": GlobalFunction.userProfile.cid.toString(),
      "date": datecontroller.text
    };
    print('ADEDEDEDD BODYDYDYDYD:::::${body}');
    var res = await http.post(
        Uri.parse(
            'https://busbooking.bestdevelopmentteam.com/Api/userhistory.php'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});
    print('RESPONSE FROM DB::::::${res.body}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      return (data['tickit'] as List)
          .map((e) => TicketHistoryM.fromJson(e))
          .toList();
    } else {
      throw ('Error');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    datecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.primary,
        centerTitle: true,
        title: const Text("My Tickets",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 8, right: 8),
                child: TextField(
                  // Date Select
                  controller: datecontroller,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2050),
                    );
                    if (pickedDate != null) {
                      print(pickedDate);
                      String formateDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(formateDate);
                      setState(() {
                        datecontroller.text = formateDate;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please Select Date !!"),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondary,
                    isDense: true,
                    // prefixIcon: Icon(Icons.date_range, color: AppColors.primary),
                    prefixIcon: Icon(Icons.calendar_month_outlined,
                        color: AppColors.primary),
                    labelText: "Day*",
                    hintText: "Select Date",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: getTicketHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primary,
                      )),
                    );
                  } else if (datecontroller.text.isEmpty) {
                    return Center(
                        child: Text('Please Select Date',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)));
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                          child: Text(
                        '${snapshot.error}',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      )),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('Tickets are not available on this date',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)));
                  } else {
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final tData = snapshot.data![index];
                          return Card(
                            elevation: 2,
                            shadowColor: Colors.grey,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Bus Name : ${tData.busname} Travel"),
                                  Text("Ticket No : ${tData.tickitno}"),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "From : ${tData.start.toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Arrival Time : ${tData.reportingTime.toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "To : ${tData.end.toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "DepatureTime : ${tData.depatureTime.toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Price : ${tData.amount.toString()}"),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: tData.passenger!.length,
                                    itemBuilder: (context, index) {
                                      final pdetail = tData.passenger![index];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Name:${pdetail.name.toString()}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  'SeatNo:${pdetail.seatno.toString()}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      /*    body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(top: 30,right: 50,left: 50),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Source",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                      IconButton(icon: const Icon(Icons.swap_horiz, color: Colors.black), onPressed: () {},),
                      Text("Destination",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text("Date : 12/12/2025"),
                  SizedBox(height: 10,),
                  Text("Arrival Time : 12/12/2025"),
                  Text("Departure Time : 12/12/2025"),
                  SizedBox(height: 15,),
                  DottedLine(dashLength: 5,dashColor: Colors.black,lineThickness: 2,dashGapLength: 6,),
                  SizedBox(height: 15,),
                  Text("TICKET NUMBER : 1234567890",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                  SizedBox(height: 10,),
                  Text("Total Seat : 2",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                  SizedBox(height: 10,),
                  Text("Total Price : ₹ 1350",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30,),
                      child: Container(
                          height: 40,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 98, 96, 1),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: const Center(
                              child: Text("Show Passangers Details", style: TextStyle(fontSize: 18,color: Colors.white,),)
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),*/
    );
  }
}
