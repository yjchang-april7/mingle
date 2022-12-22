import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/models/chat.dart';
import 'package:mingle/models/user.dart';
import 'package:mingle/providers/chat.dart';
import 'package:mingle/providers/user_data.dart';
import 'package:mingle/themes.dart';
import 'package:mingle/widgets/send_message.dart';

class ChatPage extends ConsumerWidget {
  final String collectionId;
  final MingleUser chatUser;

  ChatPage({required this.collectionId, required this.chatUser, Key? key})
      : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MingleUser? user = ref.watch(currentLoggedUserProvider);
    final chatList = ref.watch(chatProvider(collectionId));

    Future<void> sendMessage(String message) async {
      if (message.isEmpty) {
        return;
      }

      Chat data = Chat(
          senderName: user!.name,
          senderId: user.id,
          message: message,
          time: DateTime.now());

      try {
        await ref.watch(chatProvider(collectionId).notifier).sendMessage(data);

        _textController.clear();
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: MingleTheme.navyblueshade4,
        leadingWidth: 20,
        elevation: 0,
        title: ListTile(
          leading: (chatUser.image != null)
              ? CircleAvatar(
                  backgroundImage: MemoryImage(chatUser.image!),
                )
              : CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
          title: Text(chatUser.name),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              )),
        ],
      ),
      body: Scaffold(
        body: ListView(
          children: [
            ...chatList,
          ],
        ),
        bottomNavigationBar: SendMessageWidget(
          textController: _textController,
          onSend: () async => await sendMessage(_textController.text),
        ),
      ),
    );
  }
}
