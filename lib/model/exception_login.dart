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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['error'] = this.error;
    return data;
  }
}
