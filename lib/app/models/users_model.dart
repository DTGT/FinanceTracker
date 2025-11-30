import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettings {
  final String? uid;
  final String? email;
  String? name;
  final String? profilePhotoUrl;
  final String? currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSettings({
    required this.uid,
    required this.email,
    required this.name,
    this.profilePhotoUrl,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePhotoUrl: map['profile_photo_url'],
      currency: map['currency'] ?? 'PHP',
      createdAt: (map['created_at'] as Timestamp).toDate(),
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profile_photo_url': profilePhotoUrl,
      'currency': currency,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
