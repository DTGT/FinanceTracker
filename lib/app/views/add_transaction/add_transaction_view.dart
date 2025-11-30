import 'package:financial_tracker/widgets/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:financial_tracker/widgets/app_header.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: TransactionForm(onSave: () {}),
        ),
      ),
    );
  }
}
