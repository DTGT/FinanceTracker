import 'package:flutter/material.dart';
import 'package:financial_tracker/widgets/app_header.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
 Widget build(BuildContext context) {
    return AppHeader(
      child: Center(
        child: Text("Transaction History"),
      ),
    );
  }
}
