// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

class Authentication {
  final Client client;
  late Account account;

  Authentication(this.client) {
    account = Account(client);
  }

  Future<void> login(String email, String password) async {
    try {
      await account.createEmailSession(email: email, password: password);
    } on Exception catch (e) {
      debugPrint('Logged Error\n${e.toString()}');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await account.create(
          userId: ID.unique(), email: email, password: password);
      await account.createEmailSession(email: email, password: password);
    } on Exception catch (e) {
      debugPrint('Signup Error\n${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } on Exception catch (e) {
      debugPrint('Logout Error\n${e.toString()}');
    }
  }
}
