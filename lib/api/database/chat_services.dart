import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/models/chat.dart';
import 'package:mingle/models/user.dart';
import 'package:mingle/themes.dart';
import 'package:mingle/utils/api.dart';

class ChatServicesNotifier extends StateNotifier<List<ChatBubble>> {
  final Client client;
  final String collectionId;
  late final Databases database;
  late final Account account;
  late final Realtime realtime;
  late RealtimeSubscription subscription;

  final List<Chat> _chats = [];
  final MingleUser? user;

  List<Chat> get chats => _chats;

  ChatBubble _parseChat(Chat chat) {
    return ChatBubble(
      margin: const EdgeInsets.only(top: 10),
      alignment:
          user!.id == chat.senderId ? Alignment.topRight : Alignment.topLeft,
      shadowColor: Colors.transparent,
      backGroundColor:
          user!.id != chat.senderId ? Colors.grey : MingleTheme.lightBlueShade,
      clipper: ChatBubbleClipper1(
        type: user!.id == chat.senderId
            ? BubbleType.sendBubble
            : BubbleType.receiverBubble,
      ),
      child: Text(chat.message),
    );
  }

  ChatServicesNotifier(
      {required this.client, this.user, required this.collectionId})
      : super([]) {
    database = Databases(client);
    account = Account(client);
    realtime = Realtime(client);
    subscription = realtime.subscribe(
      ['databases.${ApiInfo.databaseId}.collections.$collectionId.documents'],
    );

    _getOldMessages(user);
    _getRealtimeMessages();
  }

  Future<void> sendMessage(Chat chat) async {
    try {
      await database.createDocument(
        databaseId: ApiInfo.databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: chat.toMap(),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> _getOldMessages(MingleUser? user) async {
    try {
      final models.DocumentList temp = await database.listDocuments(
          databaseId: ApiInfo.databaseId, collectionId: collectionId);
      final response = temp.documents;

      for (var element in response) {
        _chats.add(Chat.fromMap(element.data));
      }

      state = _chats.map((e) => _parseChat(e)).toList();
    } on AppwriteException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  void _getRealtimeMessages() {
    subscription.stream.listen((chat) {
      Chat data = Chat.fromMap(chat.payload);
      _chats.add(data);

      state = [...state, _parseChat(data)];
    });
  }

  @override
  void dispose() {
    subscription.close();
    log('Stream Closed');
    super.dispose();
  }
}
