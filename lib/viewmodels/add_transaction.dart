import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_tracker/models/transactions.dart';

class AddTransactionViewModel extends ChangeNotifier {
  // Form fields
  DateTime selectedDate = DateTime.now();
  String? type;
  String? mainCategory;
  String? subCategory;
  String? description;
  double? amount;
  String? fundSource;
  String? fundDestination;
  double? fee;
  String? notes;
  String? txnId;

  // Loading state
  bool isLoading = false;

  // Category options
  final List<String> types = ['Income', 'Expense', 'Transfer'];
  final List<String> mainCategories = ['Food', 'Travel', 'Salary', 'Others'];
  final Map<String, List<String>> subCategories = {
    'Food': ['Groceries', 'Dining', 'Snacks'],
    'Travel': ['Taxi', 'Flight', 'Hotel'],
    'Salary': ['Monthly', 'Bonus'],
    'Others': ['Misc']
  };
  final List<String> fundSources = ['Bank', 'Wallet', 'Cash'];
  final List<String> fundDestinations = ['Bank', 'Wallet', 'Cash'];

  void pickDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setType(String? val) {
    type = val;
    if (type != 'Transfer') fundDestination = null;
    notifyListeners();
  }

  void setMainCategory(String? val) {
    mainCategory = val;
    subCategory = null;
    notifyListeners();
  }

  void setSubCategory(String? val) {
    subCategory = val;
    notifyListeners();
  }

  void setDescription(String? val) {
    description = val;
    notifyListeners();
  }

  void setAmount(double? val) {
    amount = val;
    notifyListeners();
  }

  void setFundSource(String? val) {
    fundSource = val;
    notifyListeners();
  }

  void setFundDestination(String? val) {
    fundDestination = val;
    notifyListeners();
  }

  void setFee(double? val) {
    fee = val;
    notifyListeners();
  }

  void setNotes(String? val) {
    notes = val;
    notifyListeners();
  }

  void setTxnId(String? val) {
    txnId = val;
    notifyListeners();
  }

 String? message;
  bool isSuccess = true;

  Future<void> submitTransaction() async {
    isLoading = true;
    notifyListeners();

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String? userEmail = user?.email;
      final id = txnId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final txn = TransactionModel(
        id: id,
        date: selectedDate,
        type: type!,
        mainCategory: mainCategory!,
        subCategory: subCategory,
        description: description,
        amount: amount!,
        fundSource: fundSource!,
        fundDestination: fundDestination,
        fee: fee,
        notes: notes,
        userEmail: userEmail!,
      );

      await FirebaseFirestore.instance
          .collection('Transactions')
          .doc(id)
          .set(txn.toMap());

      message = 'Transaction saved successfully!';
      isSuccess = true;
    } catch (e) {
      message = 'Failed to save transaction: $e';
      isSuccess = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    message = null;
    notifyListeners();
  }
}
