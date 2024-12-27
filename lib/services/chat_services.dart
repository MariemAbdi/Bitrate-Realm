import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch messages for a specific user
  Stream<List<Chat>> fetchAllMessages(String userId) {
    try {
      // Query all chat documents where the user is involved
      final query = _firestore
          .collection('users')
          .doc(userId)
          .collection('chat')
          .orderBy('lastSent', descending: true);

      // Listen to the query and map changes into a stream of Chat objects with IDs
      return query.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          // Create a Chat object with the document ID included
          final chat = Chat.fromJson(doc.data());
          return chat.copyWith(id: doc.id); // Assuming Chat has a copyWith method
        }).toList();
      });
    } catch (e) {
      debugPrint('Error streaming messages: $e');
      // Return an empty stream in case of an error
      return const Stream.empty();
    }
  }


  // Fetch the chat details for a user
  Stream<List<Message>> getMessages({required String userId, required String receiver}) {
    try {
      final messagesStream = _firestore
          .collection('users')
          .doc(userId)
          .collection('chat')
          .doc(receiver)
          .collection('messages')
          .orderBy('date', descending: true)
          .snapshots();

      // Map the query snapshot to a list of Message objects
      return messagesStream.map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Message.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      debugPrint('Error streaming messages: $e');
      // Return an empty stream in case of error
      return const Stream.empty();
    }
  }

  sendMessage(Message message)async{
    await _firestore
        .collection('users')
        .doc(message.sender)
        .collection('chat')
        .doc(message.receiver)
        .collection('messages').add(message.toJson());

    await _firestore
        .collection('users')
        .doc(message.receiver)
        .collection('chat')
        .doc(message.sender)
        .collection('messages').add(message.toJson());

    updateChat(message);
  }

  Future<void> updateChat(Message message) async {
    try {
      // Reference to the specific chat document
      final receiverReference  = _firestore
          .collection("users")
          .doc(message.receiver)
          .collection('chat')
          .doc(message.sender);
      final senderReference  = _firestore
          .collection("users")
          .doc(message.sender)
          .collection('chat')
          .doc(message.receiver);

      Chat updatedReceiverChat, updatedSenderChat;
      final receiverDocSnapshot = await receiverReference.get();
      final senderDocSnapshot = await senderReference.get();
      if (receiverDocSnapshot.exists) {
        // Convert Firestore data to Chat model
        final receiverChat = Chat.fromJson(receiverDocSnapshot.data()!);
        final senderChat = Chat.fromJson(senderDocSnapshot.data()!);

        // THE RECEIVER GETS +1
        updatedReceiverChat = receiverChat.copyWith(
          lastMessage: message.message,
          lastSender: message.sender,
          lastSent: message.date,
          count: receiverChat.count + 1,
        );

        // THE SENDER DOESN'T GET +1
        updatedSenderChat = senderChat.copyWith(
          lastMessage: message.message,
          lastSender: message.sender,
          lastSent: message.date,
          count: senderChat.count,
        );
      } else {
        // THE RECEIVER GETS 1
        updatedReceiverChat = Chat(
          lastMessage: message.message,
          lastSender: message.sender,
          lastSent: message.date,
          count: 1,
        );

        // THE SENDER DOESN'T GET 0
        updatedSenderChat = Chat(
          lastMessage: message.message,
          lastSender: message.sender,
          lastSent: message.date,
          count: 0,
        );
      }

      // Save the updated Chat back to Firestore
      await receiverReference.set(updatedReceiverChat.toJson(), SetOptions(merge: true));
      await senderReference.set(updatedSenderChat.toJson(), SetOptions(merge: true));

      debugPrint("Chat document updated successfully.");
    } catch (e) {
      debugPrint("Failed to update chat document: $e");
    }
  }

  Future<void> resetChatCount(String receiverId, String senderId) async {
    try {
      // Reference to the chat document
      final docRef = _firestore
          .collection("users")
          .doc(receiverId)
          .collection('chat')
          .doc(senderId);

      // Update only the 'count' field to 0
      await docRef.update({'count': 0});

      debugPrint("Chat count reset to 0 successfully.");
    } catch (e) {
      debugPrint("Error resetting chat count: $e");
      // Handle the case where the document doesn't exist
      if (e is FirebaseException && e.code == 'not-found') {
        debugPrint("Chat document not found.");
      }
    }
  }


}
