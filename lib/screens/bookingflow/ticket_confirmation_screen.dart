import 'dart:convert';

import 'package:bus_buddy/utils/app_urls.dart';

import '../../utils/global_function.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../bottombar_screen.dart';
import '../../model/showticketmodel.dart';
import '../../utils/appcolor.dart';

class ConfirmTickets extends StatefulWidget {
  final String? ticketNo;
  final String? cId;

  const ConfirmTickets({super.key, this.ticketNo, this.cId});

  @override
  State<ConfirmTickets> createState() => _TicketsState();
}

class _TicketsState extends State<ConfirmTickets> {
  Future<List<ShowTicket>> displayTicket() async {
    var res = await http.post(Uri.parse(AppUrls.ticketConfirm),
        body: jsonEncode({
          "ticketno": widget.ticketNo.toString(),
        }),
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200 || res.statusCode == 201) {
      debugPrint('Ticket REsponse:::::${res.body}');

      var data = jsonDecode(res.body);
      return (data['tickit'] as List)
          .map((e) => ShowTicket.fromJson(e))
          .toList();
    } else {
      throw ('ERRORRR');
    }
  }

  mailTicket() async {
    var res = await http.post(
        Uri.parse(
            'https://busbooking.bestdevelopmentteam.com/Api/ticketmail.php'),
        body: jsonEncode({
          "ticketno": widget.ticketNo.toString(),
          "cid": GlobalFunction.userProfile.cid.toString()
        }),
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
      debugPrint('TICKET MAIL REESPONS${res.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('TicketNo on Confir TIcket::::${widget.ticketNo.toString()}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.primary,
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Booking Confirmed",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      const SizedBox(width: 5),
                      Image.asset("assets/images/confirm.png"),
                      // ImageIcon(AssetImage("assets/images/confirm.png")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("We have send you the ticket copy on your E-mail",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                  Text(GlobalFunction.userProfile.email.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, right: 40, left: 40),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                            height: 420,
                            width: 500,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FutureBuilder(
                              future: displayTicket(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('ERROR :::${snapshot.error}');
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        final ticket = snapshot.data![index];

                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "From : ${ticket.start.toString()}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                    "Arival Time : ${ticket.reportingTime.toString()}"),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "To : ${ticket.end.toString()}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                    "Desination Time : ${ticket.depatureTime.toString()}"),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                                "Day : ${ticket.bookingdate.toString()},  ${ticket.day.toString()}"),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const DottedLine(
                                              dashLength: 5,
                                              dashColor: Colors.black,
                                              lineThickness: 2,
                                              dashGapLength: 6,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "Bus Name : ${ticket.busname.toString()} Travel"),
                                            Text(
                                              "Ticket No : ${ticket.tickitno.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ListView.builder(
                                              itemBuilder: (context, index) {
                                                final passenger =
                                                    ticket.passenger;
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "Passanger Name : ${passenger![index].name.toString()}"),
                                                    Text(
                                                        "Seat No : ${passenger[index].seatno.toString()}")
                                                  ],
                                                );
                                              },
                                              shrinkWrap: true,
                                              itemCount:
                                                  ticket.passenger!.length,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Price = ₹${ticket.amount.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Ticket Booking Date : ${ticket.bookingdate.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              "Ticket Created Date : ${ticket.createddate.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        );
                                      },
                                      itemCount: snapshot.data!.length,
                                    ),
                                  );
                                }
                              },
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await mailTicket();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottoBar()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                                child: Text(
                              "Home",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
