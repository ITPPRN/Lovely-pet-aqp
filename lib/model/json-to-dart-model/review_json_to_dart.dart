class ReviewJsonToDart {
  int? id;
  double? rating;
  String? comment;
  int? hotelId;
  int? userId;

  ReviewJsonToDart(
      {this.id, this.rating, this.comment, this.hotelId, this.userId});

  ReviewJsonToDart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];
    hotelId = json['hotelId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['comment'] = comment;
    data['hotelId'] = hotelId;
    data['userId'] = userId;
    return data;
  }
}
