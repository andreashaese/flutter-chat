import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String author;
  final DateTime createdAt;

  Message(
      {required this.message, required this.author, required this.createdAt});

  Message.fromJson(Map<String, dynamic> json)
      : this(
          message: json["message"]! as String,
          author: json["author"]! as String,
          createdAt: (json["created_at"]! as Timestamp).toDate(),
        );

  Map<String, dynamic> toFirestore() => {
        "message": message,
        "author": author,
        "created_at": Timestamp.fromDate(createdAt),
      };
}
