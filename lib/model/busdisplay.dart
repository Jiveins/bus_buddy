class Stops {
  String? id;
  String? name;

  Stops({this.id, this.name});

  Stops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class BusDisplay {
  String? busid;
  String? busname;
  String? price;
  String? arrivalstops;
  String? arrivalTime;
  String? depaturestops;
  String? deptTime;
  int? avSeats;

  BusDisplay(
      {this.busid,
        this.busname,
        this.price,
        this.arrivalstops,
        this.arrivalTime,
        this.depaturestops,
        this.deptTime,
        this.avSeats});

  BusDisplay.fromJson(Map<String, dynamic> json) {
    busid = json['busid'];
    busname = json['busname'];
    price = json['price'];
    arrivalstops = json['Arrivalstops:'];
    arrivalTime = json['ArrivalTime'];
    depaturestops = json['depaturestops:'];
    deptTime = json['DeptTime'];
    avSeats = json['AvSeats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['busid'] = this.busid;
    data['busname'] = this.busname;
    data['price'] = this.price;
    data['Arrivalstops:'] = this.arrivalstops;
    data['ArrivalTime'] = this.arrivalTime;
    data['depaturestops:'] = this.depaturestops;
    data['DeptTime'] = this.deptTime;
    data['AvSeats'] = this.avSeats;
    return data;
  }
}
