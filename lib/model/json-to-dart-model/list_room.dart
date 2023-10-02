class ListRoomModelDart {
  int? id;
  int? roomNumber;
  String? roomDetails;
  double? roomPrice;
  String? status;
  String? type;

  ListRoomModelDart(
      {this.id,
      this.roomNumber,
      this.roomDetails,
      this.roomPrice,
      this.status,
      this.type});

  ListRoomModelDart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['roomNumber'];
    roomDetails = json['roomDetails'];
    roomPrice = json['roomPrice'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roomNumber'] = roomNumber;
    data['roomDetails'] = roomDetails;
    data['roomPrice'] = roomPrice;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}
