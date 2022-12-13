import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/models/user.dart';
import 'package:mingle/providers/client.dart';

import '../api/database/user_data.dart';

final userDataClassProvider = Provider<UserData>((ref) {
  return UserData(ref.watch(clientProvider));
});

final usersListProvider = FutureProvider<List<MingleUser>>((ref) {
  return ref.watch(userDataClassProvider).getUsersList();
});

final currentLoggedUserProvider = StateProvider<MingleUser?>((ref) {
  return null;
});
