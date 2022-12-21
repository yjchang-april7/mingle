// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:mingle/models/user.dart';
import 'package:mingle/utils/api.dart';

class UserData {
  final Client client;
  late Databases database;
  late Account account;
  late Storage storage;
  UserData(this.client) {
    account = Account(client);
    database = Databases(client);
    storage = Storage(client);
  }

  Future<void> addUser(String name, String bio, String imgId) async {
    final res = await account.get();
    log('UserData.addUser \$id=${res.$id}');
    try {
      await account.updateName(name: name);
      await database.createDocument(
          databaseId: ApiInfo.databaseId,
          collectionId: ApiInfo.userCollectionId,
          documentId: res.$id,
          data: {
            'name': name,
            'bio': bio,
            'email': res.email,
            'id': res.$id,
            'imgId': imgId
          },
          permissions: [
            Permission.read(Role.any()),
            Permission.read(Role.user(res.$id)),
          ]);
    } catch (e) {
      log('$e');
      rethrow;
    }
  }

  Future<MingleUser?> getCurrentUser() async {
    try {
      final user = await account.get();
      final data = await database.getDocument(
          databaseId: ApiInfo.databaseId,
          collectionId: ApiInfo.userCollectionId,
          documentId: user.$id);

      // avatar 이미지 요청
      final img = await _getProfilePicture(data.data['imgId']);
      return MingleUser.fromMap(data.data).copyWith(image: img);
    } on AppwriteException catch (e, st) {
      print(e);
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<MingleUser>> getUsersList() async {
    log('getUsersList');
    try {
      final response = await database.listDocuments(
          databaseId: ApiInfo.databaseId,
          collectionId: ApiInfo.userCollectionId);
      final List<MingleUser> users = [];
      final temp = response.documents;

      if (temp.isEmpty) {
        return users;
      }
      for (var element in temp) {
        final memImage =
            await _getProfilePicture(element.data['imgId'] as String);
        users.add(MingleUser.fromMap(element.data).copyWith(image: memImage));
      }
      return users;
    } on AppwriteException catch (e, st) {
      log('getUserList Error\n${e.message}');
      rethrow;
    }
  }

  Future<String?> uploadProfilePicture(
    String filePath,
    String imgName,
    Uint8List imageBytes,
  ) async {
    try {
      appwrite_models.Account res = await account.get();
      log('account.\$id = ${res.$id}');
      final bytes = imageBytes.map((e) => e).toList();

      log('storage.createFile bucketId=${ApiInfo.storageBucketId}');
      appwrite_models.File? result = await storage.createFile(
        bucketId: ApiInfo.storageBucketId,
        fileId: ID.unique(),
        file: InputFile(
          path: filePath,
          filename: imgName,
          bytes: bytes,
        ),
        permissions: [
          Permission.read(Role.any()),
          Permission.read(Role.user(res.$id)),
        ],
      );
      log('image.\$id = ${result.$id}');
      return result.$id;
    } catch (e) {
      log('storage.createFile Error \n ${(e as AppwriteException).message}');
      rethrow;
    }
  }

  Future<Uint8List?> _getProfilePicture(String fileId) async {
    try {
      final data = await storage.getFilePreview(
          bucketId: ApiInfo.storageBucketId, fileId: fileId);
      return data;
    } on AppwriteException catch (e, st) {
      log('_getProfilePicture Error \n${e.message}');
      return null;
    }
  }
}
