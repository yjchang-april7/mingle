// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter/material.dart';

class Authentication {
  final Client client;
  late Account account;

  Authentication(this.client) {
    account = Account(client);
  }

  Future<appwrite_models.Account?> getAccount() async {
    try {
      return await account.get();
    } on AppwriteException catch (e, st) {
      log('getAccount Error\n${e.message}');
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await account.createEmailSession(email: email, password: password);
    } on Exception catch (e) {
      log('Logged Error\n${e.toString()}');
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      log('account.create ${email}');
      await account.create(
          userId: ID.unique(), email: email, password: password);
      log('account.createEmailSession ${email}');
      appwrite_models.Session session =
          await account.createEmailSession(email: email, password: password);
      log('session = ${session.toString()}');
    } on Exception catch (e) {
      log('Signup Error\n${e.toString()}');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } on Exception catch (e) {
      log('Logout Error\n${e.toString()}');
      rethrow;
    }
  }
}
