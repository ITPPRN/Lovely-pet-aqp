class ListClinicModel {
  int? id;
  String? hotelName;
  String? location;
  String? hotelTel;
  double? rating;
  String? openState;
  String? verify;
  String? email;
  String? additionalNotes;
  double? latitude;
  double? longitude;

  ListClinicModel(
      {this.id,
      this.hotelName,
      this.location,
      this.hotelTel,
      this.rating,
      this.openState,
      this.verify,
      this.email,
      this.additionalNotes,
      this.latitude,
      this.longitude});

  ListClinicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotelName'];
    location = json['location'];
    hotelTel = json['hotelTel'];
    rating = json['rating'];
    openState = json['openState'];
    verify = json['verify'];
    email = json['email'];
    additionalNotes = json['additionalNotes'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hotelName'] = hotelName;
    data['location'] = location;
    data['hotelTel'] = hotelTel;
    data['rating'] = rating;
    data['openState'] = openState;
    data['verify'] = verify;
    data['email'] = email;
    data['additionalNotes'] = additionalNotes;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
