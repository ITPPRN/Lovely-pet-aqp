class BookingListJToD {
  int? id;
  String? bookingStartDate;
  String? bookingEndDate;
  String? date;
  String? paymentMethod;
  String? payment;
  String? state;
  int? roomNumber;
  Pet? pet;
  User? user;
  int? hotelId;
  double? price;
  AddSer? addSer;
  String? nameHotel;
  double? latitude;
  double? longitude;
  String? telHotel;
  String? email;
  bool? feedback;

  BookingListJToD(
      {this.id,
      this.bookingStartDate,
      this.bookingEndDate,
      this.date,
      this.paymentMethod,
      this.payment,
      this.state,
      this.roomNumber,
      this.pet,
      this.user,
      this.hotelId,
      this.price,
      this.addSer,
      this.nameHotel,
      this.latitude,
      this.longitude,
      this.telHotel,
      this.email,
      this.feedback});

  BookingListJToD.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingStartDate = json['bookingStartDate'];
    bookingEndDate = json['bookingEndDate'];
    date = json['date'];
    paymentMethod = json['paymentMethod'];
    payment = json['payment'];
    state = json['state'];
    roomNumber = json['roomNumber'];
    pet = json['pet'] != null ? Pet.fromJson(json['pet']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    hotelId = json['hotelId'];
    price = json['price'];
    addSer = json['addSer'] != null ? AddSer.fromJson(json['addSer']) : null;
    nameHotel = json['nameHotel'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    telHotel = json['telHotel'];
    email = json['email'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingStartDate'] = bookingStartDate;
    data['bookingEndDate'] = bookingEndDate;
    data['date'] = date;
    data['paymentMethod'] = paymentMethod;
    data['payment'] = payment;
    data['state'] = state;
    data['roomNumber'] = roomNumber;
    if (pet != null) {
      data['pet'] = pet!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['hotelId'] = hotelId;
    data['price'] = price;
    if (addSer != null) {
      data['addSer'] = addSer!.toJson();
    }
    data['nameHotel'] = nameHotel;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['telHotel'] = telHotel;
    data['email'] = email;
    data['feedback'] = feedback;
    return data;
  }
}

class Pet {
  int? id;
  String? petName;
  String? birthday;
  int? petTypeId;
  String? petTyName;
  int? userOwner;
  String? photoPath;

  Pet(
      {this.id,
      this.petName,
      this.birthday,
      this.petTypeId,
      this.petTyName,
      this.userOwner,
      this.photoPath});

  Pet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petName = json['petName'];
    birthday = json['birthday'];
    petTypeId = json['petTypeId'];
    petTyName = json['petTyName'];
    userOwner = json['userOwner'];
    photoPath = json['photoPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petName'] = petName;
    data['birthday'] = birthday;
    data['petTypeId'] = petTypeId;
    data['petTyName'] = petTyName;
    data['userOwner'] = userOwner;
    data['photoPath'] = photoPath;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;

  User({this.id, this.name, this.email, this.phoneNumber});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

class AddSer {
  int? id;
  String? name;
  double? price;

  AddSer({this.id, this.name, this.price});

  AddSer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
