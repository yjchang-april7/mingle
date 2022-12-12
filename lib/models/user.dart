// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:typed_data';

class MingleUser {
  final String id;
  final String uid;
  final String email;
  final String name;
  final String? bio;
  final Uint8List? image;
  final String? imgId;
  MingleUser({
    required this.id,
    required this.uid,
    required this.email,
    required this.name,
    this.bio,
    this.image,
    this.imgId,
  });

  MingleUser copyWith({
    String? id,
    String? uid,
    String? email,
    String? name,
    String? bio,
    Uint8List? image,
    String? imgId,
  }) {
    return MingleUser(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      imgId: imgId ?? this.imgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'imgId': imgId,
    };
  }

  factory MingleUser.fromMap(Map<String, dynamic> map) {
    return MingleUser(
      id: map['id'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      bio: map['bio'] != null ? map['bio'] as String : null,
      imgId: map['imgId'] != null ? map['imgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MingleUser.fromJson(String source) =>
      MingleUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MingleUser(id: $id, uid: $uid, email: $email, name: $name, bio: $bio)';
  }

  @override
  bool operator ==(covariant MingleUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.bio == bio &&
        other.image == image &&
        other.imgId == imgId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        name.hashCode ^
        bio.hashCode ^
        image.hashCode ^
        imgId.hashCode;
  }
}
