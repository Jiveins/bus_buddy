class UserProfile {
  String? cid;
  String? name;
  String? mobile;
  String? email;

  UserProfile({this.cid, this.name, this.mobile, this.email});

  UserProfile.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}
