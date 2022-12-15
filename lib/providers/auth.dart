import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/api/auth/authentication.dart';
import 'package:mingle/providers/client.dart';

final authProvider = Provider<Authentication>(
  (ref) {
    log('authProvider');
    return Authentication(ref.watch(clientProvider));
  },
);

final userProvider = FutureProvider<Account?>((ref) {
  log('userProvider');
  return ref.watch(authProvider).getAccount();
});

final userLoggedInProvider = StateProvider<bool?>(
  (ref) {
    log('userLoggedInProvider');
    return null;
  },
);
