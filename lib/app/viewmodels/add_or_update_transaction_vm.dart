import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_tracker/app/models/transactions_model.dart';
import 'package:financial_tracker/app/services/transactions_service.dart';

class AddOrUpdateTransactionViewModel extends ChangeNotifier {
  //
  final TransactionService _transactionService = TransactionService();

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
  String? txnId; // if null → new transaction, else → updating

  // Loading state
  bool isLoading = false;

  // Category options
  final List<String> types = ['Income', 'Expense', 'Transfer'];
  final List<String> mainCategories = [
    'Wants',
    'Needs',
    'Family',
    'Money Transfer',
    'Salary',
    'Refunds',
  ];
  final Map<String, List<String>> subCategories = {
    'Needs': [
      'Food',
      'Supermarket',
      'Bills/Utilities',
      'Personal Care',
      'Emergency/Miscellaneous',
      'Transportation',
    ],
    'Wants': [
      'Dining Out',
      'Entertainment',
      'Shopping',
      'Hobbies',
      'Travel',
      'Subscriptions',
      'Gifts & Donations',
      'Games',
    ],
    'Family': ['Parents', 'Siblings', 'Relatives'],
    'Salary': ['Salary'],
    'Money Transfer': ['Transfer'],
    'Refunds': ['Refund/Rebate'],
  };
  final List<String> fundSources = ['LandBank', 'GCash', 'Cash on Hand'];
  final List<String> fundDestinations = ['LandBank', 'GCash', 'Cash on Hand'];

  // Messages
  String? message;
  bool isSuccess = true;

  // --------------------------
  // Prefill from existing transaction
  // --------------------------
  void prefillFromTransaction(TransactionModel txn) {
    txnId = txn.id;
    selectedDate = txn.date;
    type = txn.type;
    mainCategory = txn.mainCategory;
    subCategory = txn.subCategory;
    description = txn.description;
    amount = txn.amount;
    fundSource = txn.fundSource;
    fundDestination = txn.fundDestination;
    fee = txn.fee;
    notes = txn.notes;
    notifyListeners();
  }

  // --------------------------
  // Helpers for form setters
  // --------------------------
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

  void clearMessage() {
    message = null;
    notifyListeners();
  }

  // --------------------------
  // Create/Update transaction
  // --------------------------
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

      // Firestore will create new doc if id doesn't exist, or overwrite existing
      if (txnId == null) {
        await _transactionService.createTransaction(txn);
      } else {
        await _transactionService.updateTransaction(txn);
      }

      message = txnId == null
          ? 'Transaction added successfully!'
          : 'Transaction updated successfully!';
      isSuccess = true;
    } catch (e) {
      message = 'Failed to save transaction: $e';
      isSuccess = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
