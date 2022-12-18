import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/pages/home/home_page.dart';
import 'package:mingle/pages/home/users_list_page.dart';
import 'package:mingle/pages/loading_page.dart';
import 'package:mingle/pages/login/create_account.dart';
import 'package:mingle/pages/login/login_page.dart';
import 'package:mingle/pages/settings/settings_page.dart';
import 'package:mingle/pages/welcome_page.dart';
import 'package:mingle/providers/auth.dart';
import 'package:mingle/providers/user_data.dart';
import 'package:mingle/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  Future<void> _init(WidgetRef ref) async {
    final user = await ref.read(userProvider.future);

    if (user != null) {
      final userData = await ref.read(userDataClassProvider).getCurrentUser();
      ref
          .read(currentLoggedUserProvider.notifier)
          .update((user) => user = userData);
      ref.read(userLoggedInProvider.notifier).update((state) => true);
    } else {
      ref.read(userLoggedInProvider.notifier).update((state) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _init(ref);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mingle',
      themeMode: ThemeMode.dark,
      darkTheme: MingleTheme.DarkTheme(),
      theme: MingleTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      home: const AuthChecker(),
      routes: {
        LoginPage.routename: (context) => const LoginPage(),
        HomePage.routename: (context) => const HomePage(),
        CreateAccountPage.routename: (context) => const CreateAccountPage(),
        UsersListPage.routename: (context) => const UsersListPage(),
        SettingsPage.routename: (context) => const SettingsPage(),
      },
    );
  }
}

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(userLoggedInProvider);
    if (isLoggedIn == true) {
      return const HomePage();
    } else if (isLoggedIn == false) {
      return const WelcomePage();
    }
    return const LoadingPage();
  }
}
