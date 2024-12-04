class ModelChat {
  String? sender;
  String? message;

  ModelChat({this.sender, this.message});

  ModelChat.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['message'] = this.message;
    return data;
  }
}
