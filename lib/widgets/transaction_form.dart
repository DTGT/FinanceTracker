import 'package:flutter/material.dart';
import 'package:financial_tracker/app/viewmodels/add_or_update_transaction_vm.dart';
import 'package:financial_tracker/app/models/transactions_model.dart';

class TransactionForm extends StatefulWidget {
  final TransactionModel? transaction; // null = add, not null = edit
  final void Function() onSave;

  const TransactionForm({super.key, this.transaction, required this.onSave});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late AddOrUpdateTransactionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddOrUpdateTransactionViewModel();

    // Prefill if editing
    if (widget.transaction != null) {
      _viewModel.prefillFromTransaction(widget.transaction!);
    }

    _viewModel.addListener(_onViewModelUpdated);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelUpdated);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelUpdated() {
    if (_viewModel.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.message!),
          backgroundColor: _viewModel.isSuccess ? Colors.green : Colors.red,
        ),
      );
      _viewModel.clearMessage();
    }
    setState(() {}); // update loading state
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _viewModel.submitTransaction();

      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------
            // Date picker
            // ----------------------
            Text('Date'),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _viewModel.selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) _viewModel.pickDate(date);
              },
              child: InputDecorator(
                decoration: InputDecoration(border: OutlineInputBorder()),
                child: Text(
                  '${_viewModel.selectedDate.year}-${_viewModel.selectedDate.month.toString().padLeft(2, '0')}-${_viewModel.selectedDate.day.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ----------------------
            // Type dropdown
            // ----------------------
            DropdownButtonFormField<String>(
              initialValue: _viewModel.type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: _viewModel.types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => _viewModel.type = val),
              validator: (val) => val == null ? 'Please select type' : null,
            ),
            const SizedBox(height: 16),

            // ----------------------
            // Main Category dropdown
            // ----------------------
            DropdownButtonFormField<String>(
              initialValue: _viewModel.mainCategory,
              decoration: const InputDecoration(labelText: 'Main Category'),
              items: _viewModel.mainCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _viewModel.mainCategory = val;
                  _viewModel.subCategory = null;
                });
              },
              validator: (val) =>
                  val == null ? 'Please select main category' : null,
            ),
            const SizedBox(height: 16),

            // ----------------------
            // Subcategory dropdown
            // ----------------------
            if (_viewModel.mainCategory != null)
              DropdownButtonFormField<String>(
                initialValue: _viewModel.subCategory,
                decoration: const InputDecoration(labelText: 'Subcategory'),
                items: _viewModel.subCategories[_viewModel.mainCategory!]!
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _viewModel.subCategory = val),
                validator: (val) =>
                    val == null ? 'Please select subcategory' : null,
              ),
            const SizedBox(height: 16),

            // ----------------------
            // Description
            // ----------------------
            TextFormField(
              initialValue: _viewModel.description,
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (val) => _viewModel.description = val,
            ),
            const SizedBox(height: 16),

            // ----------------------
            // Amount
            // ----------------------
            TextFormField(
              initialValue: _viewModel.amount?.toString(),
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || double.tryParse(val) == null
                  ? 'Enter a valid amount'
                  : null,
              onSaved: (val) => _viewModel.amount = double.tryParse(val!),
            ),
            const SizedBox(height: 16),

            // ----------------------
            // Fund Source
            // ----------------------
            DropdownButtonFormField<String>(
              initialValue: _viewModel.fundSource,
              decoration: const InputDecoration(labelText: 'Fund Source'),
              items: _viewModel.fundSources
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (val) => setState(() => _viewModel.fundSource = val),
              validator: (val) =>
                  val == null ? 'Please select fund source' : null,
            ),
            const SizedBox(height: 16),

            // ----------------------
            // Fund Destination (Transfer only)
            // ----------------------
            if (_viewModel.type == 'Transfer')
              DropdownButtonFormField<String>(
                initialValue: _viewModel.fundDestination,
                decoration: const InputDecoration(
                  labelText: 'Fund Destination',
                ),
                items: _viewModel.fundDestinations
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _viewModel.fundDestination = val),
                validator: (val) => _viewModel.type == 'Transfer' && val == null
                    ? 'Please select destination'
                    : null,
              ),
            const SizedBox(height: 16),

            // ----------------------
            // Fee (Transfer only)
            // ----------------------
            if (_viewModel.type == 'Transfer')
              TextFormField(
                initialValue: _viewModel.fee?.toString(),
                decoration: const InputDecoration(labelText: 'Fee (optional)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _viewModel.fee = double.tryParse(val ?? '0'),
              ),
            const SizedBox(height: 16),

            // ----------------------
            // Notes
            // ----------------------
            TextFormField(
              initialValue: _viewModel.notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
              onSaved: (val) => _viewModel.notes = val,
            ),
            const SizedBox(height: 24),

            // ----------------------
            // Save button with dynamic label
            // ----------------------
            Center(
              child: _viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        widget.transaction == null
                            ? 'Add Transaction'
                            : 'Update Transaction',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
