import 'package:financial_tracker/widgets/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_tracker/widgets/app_header.dart';
import 'package:financial_tracker/app/viewmodels/transaction_history.dart';
import 'package:financial_tracker/app/models/transactions.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late TransactionHistoryViewModel _transactionHistoryViewModel;

  @override
  void initState() {
    super.initState();
    _transactionHistoryViewModel = TransactionHistoryViewModel()
      ..fetchTransactions();
  }

  // Modal function to edit a transaction
  void _openEditTransaction(TransactionModel txn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: TransactionForm(
                  transaction: txn,
                  onSave: () async {
                    // Close the modal first
                    if (context.mounted) Navigator.of(context).pop();

                    _transactionHistoryViewModel.fetchTransactions();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> showConfirmDialog(
    BuildContext context, {
    String title = 'Confirm',
    String content = 'Are you sure?',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    return result ?? false; // defaults to false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _transactionHistoryViewModel,
      child: Consumer<TransactionHistoryViewModel>(
        builder: (context, viewModel, _) {
          return AppHeader(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error != null
                  ? Center(
                      child: Text(
                        'Error: ${viewModel.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : viewModel.transactions.isEmpty
                  ? const Center(child: Text('No transactions found.'))
                  : ListView.builder(
                      itemCount: viewModel.transactions.length,
                      itemBuilder: (context, index) {
                        final txn = viewModel.transactions[index];

                        final formattedDate =
                            '${txn.date.year}-${txn.date.month.toString().padLeft(2, '0')}-${txn.date.day.toString().padLeft(2, '0')}';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(child: Text(txn.type[0])),
                            title: Text(
                              txn.description ?? txn.type,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${txn.mainCategory} / ${txn.subCategory ?? 'N/A'}\n$formattedDate',
                            ),
                            isThreeLine: true,
                            trailing: SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  Text(
                                    txn.amount.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: txn.type == 'Income'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_horiz_outlined),
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        _openEditTransaction(txn);
                                      } else if (value == 'delete') {
                                        final confirmed = await showConfirmDialog(
                                          context,
                                          title: 'Delete Transaction',
                                          content:
                                              'Are you sure you want to delete this transaction?',
                                        );
                                        if (confirmed) {
                                          if (context.mounted) {
                                            await _transactionHistoryViewModel
                                                .deleteTransaction(
                                                  txn,
                                                  context,
                                                );
                                          }
                                        }
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: ListTile(
                                          title: Text('Edit'),
                                          trailing: Icon(Icons.edit_outlined),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: ListTile(
                                          title: Text('Delete'),
                                          trailing: Icon(
                                            Icons.delete_outlined,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
