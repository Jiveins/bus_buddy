class SubmitData {
  List<Data>? data;

  SubmitData({this.data});

  SubmitData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  String? gender;
  int? age;
  String? date;
  int? seatid;
  int? busid;
  int? price;
  String? start;
  String? end;
  int? cid;

  Data(
      {this.name,
        this.gender,
        this.age,
        this.date,
        this.seatid,
        this.busid,
        this.price,
        this.start,
        this.end,
        this.cid});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    age = json['age'];
    date = json['date'];
    seatid = json['seatid'];
    busid = json['busid'];
    price = json['price'];
    start = json['start'];
    end = json['end'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['date'] = this.date;
    data['seatid'] = this.seatid;
    data['busid'] = this.busid;
    data['price'] = this.price;
    data['start'] = this.start;
    data['end'] = this.end;
    data['cid'] = this.cid;
    return data;
  }
}
