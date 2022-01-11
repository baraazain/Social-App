import 'dart:core';

class ChatModel {
  String? senderId;
  String? receiverId;
  String? text;
  String? date;



  ChatModel({this.receiverId, this.date, this.text, this.senderId});

  ChatModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    date = json['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'date': date,
    };
  }
}
