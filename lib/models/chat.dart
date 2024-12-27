import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String? id; // Document ID
  final String lastSender, lastMessage;
  final DateTime lastSent;
  final int count;

  Chat({
    this.id,
    required this.lastMessage,
    required this.lastSender,
    required this.lastSent,
    required this.count,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      lastMessage: json['lastMessage'] ?? '',
      lastSender: json['lastSender'],
      lastSent: (json['lastSent'] as Timestamp).toDate(),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastMessage': lastMessage,
      'lastSender': lastSender,
      'lastSent': lastSent,
      'count': count,
    };
  }

  // Method to copy the object with new values
  // Copy the object with new values
  Chat copyWith({
    String? id,
    String? lastMessage,
    String? lastSender,
    DateTime? lastSent,
    int? count,
  }) {
    return Chat(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSender: lastSender ?? this.lastSender,
      lastSent: lastSent ?? this.lastSent,
      count: count ?? this.count,
    );
  }
}
