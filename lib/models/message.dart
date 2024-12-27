import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender, receiver, message, messageType;
  final DateTime date;

  Message({
    required this.message,
    required this.sender,
    required this.receiver,
    this.messageType = "text",
    required this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'] ?? '',
      sender: json['sender'] ?? '',
      receiver: json['receiver'] ?? '',
      messageType: json['messageType'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'messageType': messageType,
      'date': date,
    };
  }
}
