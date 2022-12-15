import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingle/utils/api.dart';

final clientProvider = Provider<Client>((ref) {
  log(ApiInfo.url);
  log(ApiInfo.projectId);
  return Client()
      .setEndpoint(ApiInfo.url)
      .setProject(ApiInfo.projectId)
      .setSelfSigned(status: true);
});

final dartClientProvider = Provider<appwrite.Client>((ref) {
  return appwrite.Client()
      .setEndpoint(ApiInfo.url)
      .setProject(ApiInfo.projectId)
      .setKey(ApiInfo.apiKey)
      .setSelfSigned(status: true);
});
