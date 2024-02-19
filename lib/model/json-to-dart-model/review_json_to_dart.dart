class ReviewJsonToDart {
  int? id;
  double? rating;
  String? comment;
  int? hotelId;
  int? userId;
  String? nameHotel;
  String? nameUser;
  String? imageUser;

  ReviewJsonToDart(
      {this.id,
      this.rating,
      this.comment,
      this.hotelId,
      this.userId,
      this.nameHotel,
      this.nameUser,
      this.imageUser});

  ReviewJsonToDart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];
    hotelId = json['hotelId'];
    userId = json['userId'];
    nameHotel = json['nameHotel'];
    nameUser = json['nameUser'];
    imageUser = json['imageUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['comment'] = comment;
    data['hotelId'] = hotelId;
    data['userId'] = userId;
    data['nameHotel'] = nameHotel;
    data['nameUser'] = nameUser;
    data['imageUser'] = imageUser;
    return data;
  }
}
