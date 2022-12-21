import 'dart:developer';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart' as models;
import 'package:mingle/utils/api.dart';
import 'package:mingle/utils/split_string.dart';

class ServerApi {
  final Client client;
  late final Account account;
  late final Databases database;

  ServerApi(this.client) {
    account = Account(client);
    database = Databases(client);
  }

  Future<String?> createConversation(
      String curruserId, String otheruserId) async {
    /// For collection id, we are using the combination of the two user id
    /// collectionId = '${curruserId/2}_${otheruserId/2}'; or
    /// collectionId = '${otheruserId/2}_${curruserId/2}';
    /// Because curruser and otheruserId is interchangable for both the users
    /// Divide by 2 means we are creating a substring of the user id of length
    /// half of the current userId.
    /// Then We are concatenating those two substring with '_'.
    /// This is the collection id.
    /// Currently this is the way, I am making the collection.
    /// OfCourse, this can be improved a lot better.
    ///
    models.Collection? collection;
    try {
      collection = await database.getCollection(
        databaseId: ApiInfo.databaseId,
        collectionId:
            '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}',
      );
    } on AppwriteException catch (e) {
      log(e.toString());
      if (e.code == 404 || e.code == 401) {
        try {
          collection = await database.getCollection(
            databaseId: ApiInfo.databaseId,
            collectionId:
                '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}',
          );
        } on AppwriteException catch (e) {
          if (e.code == 404 || e.code == 401) {
            collection = await database.createCollection(
                databaseId: ApiInfo.databaseId,
                collectionId:
                    '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}',
                name:
                    '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}',
                permissions: [
                  Permission.read(Role.user(curruserId)),
                  Permission.read(Role.user(otheruserId)),
                  Permission.write(Role.user(curruserId)),
                  Permission.write(Role.user(otheruserId)),
                ]);
          } else {
            rethrow;
          }
        }
      } else {
        rethrow;
      }
    }

    if (collection.attributes.isEmpty) {
      await _defineDocument(collection.$id);
    }

    return collection.$id;
  }

  Future<void> _defineDocument(String collectionId) async {
    try {
      await database.createStringAttribute(
          databaseId: ApiInfo.databaseId,
          collectionId: collectionId,
          key: "sender_name",
          size: 255,
          xrequired: true);
      await database.createStringAttribute(
          databaseId: ApiInfo.databaseId,
          collectionId: collectionId,
          key: "sender_id",
          size: 255,
          xrequired: true);
      await database.createStringAttribute(
          databaseId: ApiInfo.databaseId,
          collectionId: collectionId,
          key: "message",
          size: 255,
          xrequired: true);
      await database.createStringAttribute(
          databaseId: ApiInfo.databaseId,
          collectionId: collectionId,
          key: "time",
          size: 255,
          xrequired: true);
      await database.createEnumAttribute(
          databaseId: ApiInfo.databaseId,
          collectionId: collectionId,
          key: "message_type",
          elements: ["IMAGE", "VIDEO", "TEXT"],
          xdefault: "TEXT",
          xrequired: false);
    } on AppwriteException catch (e) {
      log('_defineDocument Error \n${e.message}');
      rethrow;
    }
  }
}
