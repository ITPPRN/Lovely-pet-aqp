class ResponseRegister {
  int? id;
  String? userName;
  String? name;
  String? email;
  String? phoneNumber;

  ResponseRegister(
      {this.id, this.userName, this.name, this.email, this.phoneNumber});

  ResponseRegister.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
