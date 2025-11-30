import 'package:financial_tracker/app/models/transactions_model.dart';
import 'package:financial_tracker/app/services/transactions_service.dart';
import 'package:flutter/material.dart';

class TransactionHistoryViewModel extends ChangeNotifier {
  List<TransactionModel> transactions = [];
  bool isLoading = false;
  String? error;
  final TransactionService _service = TransactionService();

  Future<void> fetchTransactions() async {
    isLoading = true;
    notifyListeners();

    try {
      _service.userEmail; // check if user is logged in
      transactions = await _service
          .getTransactions(); // get all user transactions

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isSuccess = false;
  String message = '';
  Future<void> deleteTransaction(
    TransactionModel txn,
    BuildContext context,
  ) async {
    try {
      await _service.deleteTransaction(txn.id);
      message = 'Transaction deleted successfully!';
      isSuccess = true;
      notifyListeners();
    } catch (e) {
      message = 'Failed to delete transaction: $e';
      isSuccess = false;
      notifyListeners();
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
        ),
      );
    }
    await fetchTransactions();
  }
}
