import 'dart:convert';

import 'package:bus_buddy/utils/global_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bus_buddy/screens/bookingflow/add_passenger_details_screen.dart';
import 'package:bus_buddy/model/busdisplay.dart';
import 'package:bus_buddy/model/seatselect.dart';
import 'package:bus_buddy/utils/appcolor.dart';

class SeatSelect extends StatefulWidget {
  final BusDisplay? bus;
  final String? cId;
  final String? price;
  final String? start;
  final String? end;
  final String busID;
  final String date;

  const SeatSelect(
      {super.key,
      required this.busID,
      required this.date,
      this.start,
      this.end,
      this.bus,
      this.price,
      this.cId});

  @override
  State<SeatSelect> createState() => _SeatSelectState();
}

class _SeatSelectState extends State<SeatSelect> {
  double totalPrice = 0.0;

  List<SeatSel> seat = [];
  int noOfSeats = 0;
  List<SeatSel> selectSeatList = [];

  void _getSeat() async {
    var res = await http.post(
        Uri.parse('https://busbooking.bestdevelopmentteam.com/Api/setas.php'),
        body: jsonEncode(
            {"bus_id": widget.busID, "date": widget.date.toString()}),
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      seat = (data['seats'] as List).map((e) => SeatSel.fromJson(e)).toList();
      debugPrint(res.body);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getSeat();
  }

  getListOfSelectedSeats() {
    noOfSeats = 0;
    selectSeatList.clear();
    totalPrice = 0.0;
    for (var element in seat) {
      if (element.userSelected! && element.bookedStatus == false) {
        noOfSeats++;
        selectSeatList.add(SeatSel(
          seatNo: element.seatNo!,
          userSelected: element.userSelected,
          bookedStatus: element.bookedStatus,
          name: TextEditingController(),
          age: TextEditingController(),
        ));
      } else {
        continue;
      }
    }
    totalPrice = selectSeatList.length * double.parse(widget.price!);
    debugPrint("Total Price: $totalPrice");
    // debugPrint("total Selected Seats $noOfSeats");
    debugPrint("total Selected Seats {${jsonEncode(selectSeatList)}");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Cid on SeatSelection:::${widget.cId}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Choose your seat!",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  height: 140,
                  // height: 313,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    color: AppColors.primary,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.start.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                height: 1,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.swap_vert_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {},
                          ),
                          Text(
                            widget.end.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Date :\t\t",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(238, 238, 238, 1)),
                          ),
                          Text(
                            widget.date.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(238, 238, 238, 1)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150, left: 40),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        color: Colors.grey,
                      ),
                      const Text("\t\tAvailable"),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        color: AppColors.primary,
                      ),
                      const Text("\t\tYour Seat"),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        color: AppColors.secondary,
                      ),
                      const Text("\t\tBooked"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 178, left: 30, right: 30, bottom: 60),
                  child: Card(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        // childAspectRatio:1/2
                      ),
                      itemCount: seat.length,
                      itemBuilder: (context, index) {
                        final s = seat[index];
                        final color = s.bookedStatus == true
                            ? AppColors.secondary
                            : s.userSelected == true
                                ? AppColors.primary
                                : Colors.grey;

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (seat[index].userSelected == false) {
                                    if (noOfSeats < 5) {
                                      seat[index].userSelected =
                                          !seat[index].userSelected!;
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.secondary,
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.only(
                                              bottom: 5, left: 10, right: 10),
                                          elevation: 2,
                                          content: const Text(
                                            "Bas bhai kitni add krega!",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    seat[index].userSelected =
                                        !seat[index].userSelected!;
                                  }
                                  getListOfSelectedSeats();
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: const AssetImage(
                                            "assets/images/feature/Seat.png",
                                          ),
                                          colorFilter: ColorFilter.mode(
                                              color, BlendMode.modulate)),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 30,
                  right: 30,
                  child: GestureDetector(
                    onTap: () {
                      if (selectSeatList.isNotEmpty) {
                        showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return SizedBox(
                                height: 250,
                                width: 500,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, right: 10, left: 10, bottom: 20),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: AppColors.secondary,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Text(widget.bus!.busid.toString(),style: TextStyle(color: Colors.white),),
                                          Text(
                                            'Your Seat : ${selectSeatList.map((seat) => seat.seatNo).toList().join(', ')}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Bus Name : ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                widget.bus!.busname.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Arrival Time : ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black)),
                                              Text(
                                                widget.bus!.arrivalTime
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Departure Time : ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black)),
                                              Text(
                                                widget.bus!.deptTime.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Available Seat : ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black)),
                                              Text(
                                                widget.bus!.avSeats.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("Price : ₹ ",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black)),
                                              Text(
                                                totalPrice.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          // ElevatedButton(
                                          //     onPressed: () {
                                          //       Navigator.push(
                                          //           context,
                                          //           MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 PassDeatils(
                                          //                     cId: widget.cId,
                                          //                     date:
                                          //                     widget.date,
                                          //                     busId: widget
                                          //                         .busID,
                                          //                     start: widget
                                          //                         .start,
                                          //                     price: widget
                                          //                         .price,
                                          //                     end: widget.end,
                                          //                     seat:
                                          //                     selectSeatList),
                                          //           )
                                          //       );
                                          //     },
                                          //     child:
                                          //     Text("Confirm Your Seat!!")
                                          // ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PassDeatils(
                                                              cId: GlobalFunction
                                                                  .userProfile
                                                                  .cid
                                                                  .toString(),
                                                              date: widget.date,
                                                              busId:
                                                                  widget.busID,
                                                              start:
                                                                  widget.start,
                                                              price: totalPrice
                                                                  .toString(),
                                                              end: widget.end,
                                                              seat:
                                                                  selectSeatList),
                                                    ));
                                              },
                                              child: Container(
                                                width: 200,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.primary,
                                                ),
                                                child: const Center(
                                                    child: Text(
                                                  "Confirm Your Seat!!",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: AppColors.secondary,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            content: const Text(
                              'Please select Seat!!',
                              style: TextStyle(color: Colors.black),
                            )));
                      }
                      return;
                    },
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary,
                      ),
                      child: const Center(
                          child: Text(
                        "Confirm Ticket",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
