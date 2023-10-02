class ExceptionLogin {
  String? timestamp;
  int? status;
  String? error;

  ExceptionLogin({this.timestamp, this.status, this.error});

  ExceptionLogin.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['status'] = status;
    data['error'] = error;
    return data;
  }
}
