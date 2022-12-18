import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/providers/client.dart';

import '../api/database/server_api.dart';

final serverProvider = Provider<ServerApi>((ref) {
  return ServerApi(ref.watch(dartClientProvider));
});
