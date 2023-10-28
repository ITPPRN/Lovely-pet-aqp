class AdditionalServiceDartModel {
  int? id;
  String? name;
  double? price;

  AdditionalServiceDartModel({this.id, this.name, this.price});

  AdditionalServiceDartModel.fromJson(Map<String, dynamic> json) {
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
