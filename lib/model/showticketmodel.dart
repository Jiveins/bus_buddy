class ShowTicket {
  String? start;
  String? end;
  String? amount;
  String? bookingdate;
  String? day;
  String? busname;
  String? reportingTime;
  String? depatureTime;
  String? tickitno;
  String? createddate;
  List<Passenger>? passenger;

  ShowTicket(
      {this.start,
        this.end,
        this.amount,
        this.bookingdate,
        this.day,
        this.busname,
        this.reportingTime,
        this.depatureTime,
        this.tickitno,
        this.createddate,
        this.passenger});

  ShowTicket.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    amount = json['amount'];
    bookingdate = json['bookingdate'];
    day = json['day'];
    busname = json['busname'];
    reportingTime = json['ReportingTime'];
    depatureTime = json['DepatureTime'];
    tickitno = json['tickitno'];
    createddate = json['createddate'];
    if (json['passenger'] != null) {
      passenger = <Passenger>[];
      json['passenger'].forEach((v) {
        passenger!.add(new Passenger.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['amount'] = this.amount;
    data['bookingdate'] = this.bookingdate;
    data['day'] = this.day;
    data['busname'] = this.busname;
    data['ReportingTime'] = this.reportingTime;
    data['DepatureTime'] = this.depatureTime;
    data['tickitno'] = this.tickitno;
    data['createddate'] = this.createddate;
    if (this.passenger != null) {
      data['passenger'] = this.passenger!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Passenger {
  String? name;
  String? seatno;

  Passenger({this.name, this.seatno});

  Passenger.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    seatno = json['seatno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['seatno'] = this.seatno;
    return data;
  }
}
