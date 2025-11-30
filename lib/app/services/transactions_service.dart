import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_tracker/app/models/transactions_model.dart';

class TransactionService {
  final _db = FirebaseFirestore.instance;

  String get userEmail {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) throw Exception("User not logged in");
    return email;
  }

  // CREATE
  Future<void> createTransaction(TransactionModel txn) async {
    await _db.collection('Transactions').doc(txn.id).set(txn.toMap());
  }

  // READ (fetch all for user)
  Future<List<TransactionModel>> getTransactions() async {
    final snapshot = await _db
        .collection('Transactions')
        .where('user_email', isEqualTo: userEmail)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList();
  }

  // UPDATE
  Future<void> updateTransaction(TransactionModel txn) async {
    await _db.collection('Transactions').doc(txn.id).update(txn.toMap());
  }

  // DELETE
  Future<void> deleteTransaction(String id) async {
    await _db.collection('Transactions').doc(id).delete();
  }
}
