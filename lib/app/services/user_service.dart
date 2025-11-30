import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_tracker/app/models/users_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  String get _uid {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in");
    }
    return uid;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> get userDoc async {
    return await _db.collection('UserSettings').doc(_uid).get();
  }

  Future<void> createUserRecord(UserSettings user) async {
    await _db.collection('UserSettings').doc(user.uid).set(user.toMap());
  }

  Future<UserSettings?> getUser() async {
    final doc = await _db.collection('UserSettings').doc(_uid).get();

    if (!doc.exists) return null;

    return UserSettings.fromMap(doc.data()!);
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    await _db.collection('UserSettings').doc(_uid).update(data);
  }

  Future<void> updateCurrency(String currency) async {
    await updateUser({'currency': currency, 'updated_at': DateTime.now()});
  }

  Future<void> updateUserName(String name) async {
    await updateUser({'name': name, 'updated_at': DateTime.now()});
  }
}
