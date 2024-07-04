import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bookingflow/showpass_details.dart';
import '../../utils/global_function.dart';
import '../../utils/appcolor.dart';
import '../../model/seatselect.dart';

class PassDeatils extends StatefulWidget {
  final List<SeatSel>? seat;
  final String? cId;
  final String? date;
  final String? busId;
  final String? start;
  final String? end;
  final String? price;

  const PassDeatils(
      {super.key,
      this.start,
      this.end,
      this.price,
      this.seat,
      this.cId,
      this.date,
      this.busId});

  @override
  State<PassDeatils> createState() => _PassDeatilsState();
}

class _PassDeatilsState extends State<PassDeatils> {
  List<SeatSel> addPasengers = [];

  submitPasengerDetails() {
    addPasengers.clear();
    for (var element in widget.seat!) {
      if (element.name.toString().isNotEmpty) {
        addPasengers.add(SeatSel(
            name: element.name,
            age: element.age,
            seatNo: element.seatNo,
            selecctRadio: element.selecctRadio,
            userSelected: element.userSelected));
      }
    }
    for (var element in addPasengers) {
      print("Name: ${element.name.text},"
          "Age:${element.age.text},"
          "UserSelected:${element.userSelected.toString()},"
          "SeatNo:${element.seatNo}"
          "Gender:${element.selecctRadio}");
    }
    setState(() {});
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('CID ON ADD PASS:::${widget.cId}');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          surfaceTintColor: AppColors.primary,
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.group,
                      color: Colors.black,
                      size: 35,
                    ),
                    Text(
                      "\t\t" "Traveller Information",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print(widget.seat![index].seatNo);
                        },
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Pasenger No : ${index + 1}',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "\t\t\t"
                                      'SeatNo : ${widget.seat![index].seatNo}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    // For Name
                                    controller: widget.seat![index].name,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.secondary,
                                        isDense: true,
                                        labelText: "Name*",
                                        prefixIcon: Icon(
                                          CupertinoIcons.person_alt_circle,
                                          color: AppColors.primary,
                                          size: 22,
                                        ),
                                        hintText: 'Name',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                        )),
                                    keyboardType: TextInputType.name,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Name is required';
                                      }
                                      return (RegExp(r'[!@#%^&*0-9]')
                                              .hasMatch(value))
                                          ? 'Please enter alphabets only'
                                          : null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 10, right: 10),
                                  child: TextFormField(
                                    //For Age
                                    controller: widget.seat![index].age,
                                    decoration: InputDecoration(
                                        labelText: "Age*",
                                        hintText: 'Age',
                                        filled: true,
                                        isDense: true,
                                        fillColor: AppColors.secondary,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.secondary),
                                        )
                                        // prefixIcon: Icon(Icons.age, color: Colors.blue)
                                        ),
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Age is required';
                                      }
                                      if (!RegExp(r'^[0-9]+$')
                                          .hasMatch(value)) {
                                        return 'Enter only numbers';
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Gender :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Radio(
                                          value: 'Male',
                                          activeColor: AppColors.primary,
                                          groupValue:
                                              widget.seat![index].selecctRadio,
                                          onChanged: (String? value) {
                                            setState(() {
                                              widget.seat![index].selecctRadio =
                                                  value!;
                                            });
                                          }),
                                      const Text('Male'),
                                      Radio(
                                          value: 'Female',
                                          activeColor: AppColors.primary,
                                          groupValue:
                                              widget.seat![index].selecctRadio,
                                          onChanged: (String? value) {
                                            setState(() {
                                              widget.seat![index].selecctRadio =
                                                  value!;
                                            });
                                          }),
                                      const Text('FeMale'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.seat!.length,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    submitPasengerDetails();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowPassenger(
                            addPasengers: addPasengers,
                            date: widget.date,
                            price: widget.price,
                            start: widget.start,
                            end: widget.end,
                            busId: widget.busId,
                            cId: GlobalFunction.userProfile.cid.toString(),
                          ),
                        ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Fill Passenger deatails !!')));
                    return;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary,
                    ),
                    child: const Center(
                        child: Text(
                      "Proceed to Book",
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
        ));
  }
}
