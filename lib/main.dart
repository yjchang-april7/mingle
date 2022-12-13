import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/providers/auth.dart';
import 'package:mingle/providers/user_data.dart';

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
    return MaterialApp();
  }
}
