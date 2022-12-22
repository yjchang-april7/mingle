// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
}

class Chat {
  final String senderName;
  final String senderId;
  final String message;
  final MessageType type;
  final DateTime time;
  Chat({
    required this.senderName,
    required this.senderId,
    required this.message,
    this.type = MessageType.TEXT,
    required this.time,
  });

  Chat copyWith({
    String? senderName,
    String? senderId,
    String? message,
    MessageType? type,
    DateTime? time,
  }) {
    return Chat(
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      type: type ?? this.type,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender_name': senderName,
      'sender_id': senderId,
      'message': message,
      'message_type': type.name,
      'time': time.toIso8601String(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      senderName: map['sender_name'] as String,
      senderId: map['sender_id'] as String,
      message: map['message'] as String,
      type: MessageType.values.byName(map['message_type']),
      time: DateTime.parse(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(senderName: $senderName, senderId: $senderId, message: $message, type: $type, time: $time)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.senderName == senderName &&
        other.senderId == senderId &&
        other.message == message &&
        other.type == type &&
        other.time == time;
  }

  @override
  int get hashCode {
    return senderName.hashCode ^
        senderId.hashCode ^
        message.hashCode ^
        type.hashCode ^
        time.hashCode;
  }
}
