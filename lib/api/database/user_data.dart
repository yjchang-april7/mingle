// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/appwrite.dart';

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
}
