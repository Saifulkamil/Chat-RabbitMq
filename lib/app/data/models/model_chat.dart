import 'package:get/get.dart';

class ModelChat {
  int? id;
  String? sender;
  String? message;
  String? publicKey;
  RxBool? status; // delivered status
  RxBool? isRead; // new read status

  ModelChat({
    this.id,
    this.sender,
    this.message,
    this.publicKey,
    this.status,
    this.isRead,
  });

  ModelChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    message = json['message'];
    publicKey = json['publicKey'];
    status = (json['status'] as bool).obs;
    isRead = (json['isRead'] as bool).obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender'] = sender;
    data['status'] = status?.value;
    data['isRead'] = isRead?.value;
    data['publicKey'] = publicKey;
    data['message'] = message;
    return data;
  }
}
