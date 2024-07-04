import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../utils/global_function.dart';
import '../../model/busdisplay.dart';
import '../../utils/appcolor.dart';
import '../bookingflow/select_seat_screen.dart';

// import 'package:bus_buddy/utils/appcolor.dart';
class FindBus extends StatefulWidget {
  final String? source;
  final String? destination;
  final String? datecontroller;
  final String? cId;
  final String? pris;

  const FindBus({
    super.key,
    this.source,
    this.destination,
    this.datecontroller,
    this.cId,
    this.pris,
  });

  @override
  State<FindBus> createState() => _FindBusState();
}

class _FindBusState extends State<FindBus> {
  Future<List<BusDisplay>> _sendStops() async {
    debugPrint(widget.source);
    debugPrint(widget.destination);
    debugPrint(widget.datecontroller);

    var res = await http.post(
        Uri.parse('https://busbooking.bestdevelopmentteam.com/Api/bussrch.php'),
        body: jsonEncode({
          "start": widget.source.toString(),
          "end": widget.destination.toString(),
          "date": widget.datecontroller.toString()
        }),
        headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      debugPrint(res.body);
      return (data['data'] as List).map((e) => BusDisplay.fromJson(e)).toList();
      // return (data['data'] as List).map((e) => BusDisplay.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ');
    }
  }

  TextEditingController serch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    debugPrint('FindBUsPage${widget.cId}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Select your bus !",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Material(
                  elevation: 5,
                  borderOnForeground: true,
                  color: Colors.black45,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 10, right: 10),
                    child: TextField(
                      controller: serch,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                      decoration: InputDecoration(
                        label: const Text("Serch Your Bus..."),
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintText: "Serch Bus",
                        hintStyle: const TextStyle(color: Colors.white70),
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search_rounded),
                        prefixIconColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 260,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: AppColors.primary,
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.source.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_vert_outlined,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                        Text(
                          widget.destination.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Date:\t\t",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(238, 238, 238, 1)),
                        ),
                        Text(
                          widget.datecontroller.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(238, 238, 238, 1)),
                        ),
                        // Text(widget.dateInput.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Color.fromRGBO(238, 238, 238, 1)),),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Image(
                        // image: AssetImage("assets/images/find_page.png"),
                        image: AssetImage("assets/images/feature/findbus.png"),
                        height: 100,
                        width: 100),
                  ],
                ),
              ),

              // Bus Card
              Positioned(
                top: 245,
                left: 20,
                right: 20,
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FutureBuilder(
                      future: _sendStops(),
                      builder:
                          (context, AsyncSnapshot<List<BusDisplay>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.only(top: 150),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            'Error:${snapshot.error}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ));
                        } else if (snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text(
                            'Bus not Avilable',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.red),
                          ));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final stops = snapshot.data![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SeatSelect(
                                          busID: stops.busid.toString(),
                                          date:
                                              widget.datecontroller.toString(),
                                          start: widget.source,
                                          end: widget.destination,
                                          price: stops.price.toString(),
                                          bus: snapshot.data![index],
                                          cId: GlobalFunction.userProfile.cid
                                              .toString(),
                                        ),
                                      ));
                                  debugPrint(stops.busid.toString());
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 3,
                                  shadowColor: Colors.grey.shade50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${stops.busname.toString()} Travels",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                                "Bus ID : ${stops.busid.toString()}"),
                                            Row(
                                              children: [
                                                Text(
                                                    "Time : ${stops.arrivalTime.toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const Text('\t-\t'),
                                                Text(stops.deptTime.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                                "${stops.avSeats.toString()} Seats left",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color.fromRGBO(
                                                        67, 160, 71, 1))),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "₹${stops.price.toString()}",
                                              style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
