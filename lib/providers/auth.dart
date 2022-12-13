import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/api/auth/authentication.dart';
import 'package:mingle/providers/client.dart';

final authProvider = Provider<Authentication>(
  (ref) {
    return Authentication(ref.watch(clientProvider));
  },
);

final userProvider = FutureProvider<Account?>((ref) {
  return ref.watch(authProvider).getAccount();
});

final userLoggedInProvider = StateProvider<bool?>(
  (ref) {
    return null;
  },
);
