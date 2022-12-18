import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mingle/api/auth/authentication.dart';
import 'package:mingle/models/popup.dart';
import 'package:mingle/pages/home/users_list_page.dart';
import 'package:mingle/pages/login/login_page.dart';
import 'package:mingle/pages/settings/settings_page.dart';
import 'package:mingle/providers/auth.dart';
import 'package:mingle/providers/user_data.dart';
import 'package:mingle/themes.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routename = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final Authentication auth = ref.watch(authProvider);

  void _showError(String error) async {
    await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Something went wrong'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: const Text('Ok'),
              ),
            ],
          )),
    );
  }

  Future<void> _userLogout() async {
    try {
      await auth.logout();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logged out Successfully"),
          duration: Duration(seconds: 2),
        ),
      );

      await Navigator.of(context).pushReplacementNamed(LoginPage.routename);
    } on AppwriteException catch (e) {
      _showError(e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currUser = ref.watch(currentLoggedUserProvider);

    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
            title: const Text(
              'Mingle',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(SettingsPage.routename);
                },
                child: CircleAvatar(
                  backgroundImage: currUser?.image != null
                      ? MemoryImage(currUser!.image!) as ImageProvider
                      : const AssetImage('assets/images/avatar.png'),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              PopupMenuButton(
                onSelected: (PopupItem item) {
                  switch (item) {
                    case PopupItem.GROUP:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Wait '),
                        ),
                      );
                      break;
                    case PopupItem.SETTINGS:
                      Navigator.of(context).pushNamed(SettingsPage.routename);
                      break;
                    case PopupItem.LOGOUT:
                      _userLogout();
                      break;
                    default:
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<PopupItem>>[
                  const PopupMenuItem<PopupItem>(
                    value: PopupItem.GROUP,
                    child: const Text('New Group'),
                  ),
                  const PopupMenuItem<PopupItem>(
                    value: PopupItem.SETTINGS,
                    child: const Text('Settings'),
                  ),
                  const PopupMenuItem<PopupItem>(
                    value: PopupItem.LOGOUT,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.subtitle1,
                  children: [
                    TextSpan(text: 'Press '),
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.0,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.pen,
                          size: 16,
                        ),
                      ),
                    ),
                    TextSpan(text: ' Icon to chat '),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.of(context).pushNamed(UsersListPage.routename);
        }),
        backgroundColor: MingleTheme.whiteShade1,
        mini: true,
        child: FaIcon(
          FontAwesomeIcons.pen,
          color: MingleTheme.navyblueshade4,
        ),
      ),
    );
  }
}
