class UserProfileJToD {
  String? name;
  String? email;
  String? phoneNumber;
  String? userPhoto;

  UserProfileJToD({this.name, this.email, this.phoneNumber, this.userPhoto});

  UserProfileJToD.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    userPhoto = json['userPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['userPhoto'] = userPhoto;
    return data;
  }
}
