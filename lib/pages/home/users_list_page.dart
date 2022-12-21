import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/models/user.dart';
import 'package:mingle/pages/chat/chat_page.dart';
import 'package:mingle/providers/server.dart';
import 'package:mingle/providers/user_data.dart';

class UsersListPage extends ConsumerStatefulWidget {
  static const String routename = '/usersListPage';

  const UsersListPage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsersListPageState();
}

class _UsersListPageState extends ConsumerState<UsersListPage> {
  ListTile usersTile(
      {required String name,
      String? bio,
      required Uint8List? imageUrl,
      VoidCallback? onTap}) {
    return ListTile(
      leading: (imageUrl != null)
          ? CircleAvatar(
              backgroundImage: MemoryImage(imageUrl),
            )
          : CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
      title: Text(name),
      subtitle: Text(bio ?? ''),
      onTap: onTap ?? () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> userList = [];

    final users = ref.watch(usersListProvider).asData?.value;

    final curUser = ref.watch(currentLoggedUserProvider);

    void onTap(String userId, MingleUser user) async {
      final id = await ref
          .watch(serverProvider)
          .createConversation(curUser!.id, userId);
      if (!mounted) {
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            collectionId: id!,
            chatUser: user,
          ),
        ),
      );
    }

    users?.sort(
      (a, b) => a.name.compareTo(b.name),
    );

    users?.forEach(
      (user) async {
        if (curUser!.id != user.id) {
          userList.add(
            usersTile(
              name: user.name,
              bio: user.bio,
              imageUrl: user.image,
              onTap: () => onTap(user.id, user),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Users'),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: userList,
      ),
    );
  }
}
