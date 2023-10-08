class PetProfileJToD {
  int? id;
  String? petName;
  String? birthday;
  String? petTypeId;
  int? userOwner;
  String? photoPath;

  PetProfileJToD(
      {this.id,
      this.petName,
      this.birthday,
      this.petTypeId,
      this.userOwner,
      this.photoPath});

  PetProfileJToD.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petName = json['petName'];
    birthday = json['birthday'];
    petTypeId = json['petTypeId'];
    userOwner = json['userOwner'];
    photoPath = json['photoPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petName'] = petName;
    data['birthday'] = birthday;
    data['petTypeId'] = petTypeId;
    data['userOwner'] = userOwner;
    data['photoPath'] = photoPath;
    return data;
  }
}
