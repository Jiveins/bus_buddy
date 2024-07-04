//seat selection model class

import 'package:flutter/material.dart';

class SeatSel {
  int? seatNo;
  bool? bookedStatus;
  bool? userSelected;
  String? selecctRadio;
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  SeatSel(
      {this.seatNo,
      this.bookedStatus,
      this.userSelected,
      this.selecctRadio,
      required this.name,
      required this.age});
  SeatSel.fromJson(Map<String, dynamic> json) {
    seatNo = json['seatNo'];
    bookedStatus = json['BookedStatus'];
    userSelected = json['userSelected'] ?? false;
    selecctRadio = json['selecctRadio'] ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seatNo'] = this.seatNo;
    data['BookedStatus'] = this.bookedStatus;
    data['userSelected'] = this.userSelected;
    data['selecctRadio'] = this.selecctRadio;
    return data;
  }
}
