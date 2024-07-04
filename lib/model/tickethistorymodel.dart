class TicketHistoryM {
  String? start;
  String? end;
  String? amount;
  String? date;
  String? reportingTime;
  String? depatureTime;
  String? busname;
  String? tickitno;
  List<Passenger>? passenger;

  TicketHistoryM(
      {this.start,
        this.end,
        this.amount,
        this.date,
        this.reportingTime,
        this.depatureTime,
        this.busname,
        this.tickitno,
        this.passenger});

  TicketHistoryM.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    amount = json['amount'];
    date = json['date'];
    tickitno = json['tickitno'];
    reportingTime = json['ReportingTime'];
    depatureTime = json['DepatureTime'];
    busname = json['busname'];
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
    data['date'] = this.date;
    data['tickitno'] = this.tickitno;
    data['ReportingTime'] = this.reportingTime;
    data['DepatureTime'] = this.depatureTime;
    data['busname'] = this.busname;
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
