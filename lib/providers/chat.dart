import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/api/database/chat_services.dart';
import 'package:mingle/providers/client.dart';
import 'package:mingle/providers/user_data.dart';

final chatProvider = StateNotifierProvider.autoDispose
    .family<ChatServicesNotifier, List<ChatBubble>, String>(
        (ref, collectionId) {
  return ChatServicesNotifier(
      client: ref.watch(clientProvider),
      collectionId: collectionId,
      user: ref.watch(currentLoggedUserProvider));
});
