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

  ListClinicModel(
      {this.id,
      this.hotelName,
      this.location,
      this.hotelTel,
      this.rating,
      this.openState,
      this.verify,
      this.email,
      this.additionalNotes});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotelName'] = this.hotelName;
    data['location'] = this.location;
    data['hotelTel'] = this.hotelTel;
    data['rating'] = this.rating;
    data['openState'] = this.openState;
    data['verify'] = this.verify;
    data['email'] = this.email;
    data['additionalNotes'] = this.additionalNotes;
    return data;
  }
}
