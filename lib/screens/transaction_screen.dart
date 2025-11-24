import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  String? _type;
  String? _mainCategory;
  String? _subCategory;
  String? _description;
  double? _amount;
  String? _fundSource;
  String? _fundDestination;
  double? _fee;
  String? _notes;
  String? _txnId;

  final List<String> _types = ['Income', 'Expense', 'Transfer'];
  final List<String> _mainCategories = ['Food', 'Travel', 'Salary', 'Others'];
  final Map<String, List<String>> _subCategories = {
    'Food': ['Groceries', 'Dining', 'Snacks'],
    'Travel': ['Taxi', 'Flight', 'Hotel'],
    'Salary': ['Monthly', 'Bonus'],
    'Others': ['Misc']
  };
  final List<String> _fundSources = ['Bank', 'Wallet', 'Cash'];
  final List<String> _fundDestinations = ['Bank', 'Wallet', 'Cash'];

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) setState(() => _selectedDate = date);
  }

  void _showMessage(String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_txnId == null || _txnId!.isEmpty) {
        _txnId = DateTime.now().millisecondsSinceEpoch.toString();
      }

      final User? user = FirebaseAuth.instance.currentUser;
      final String? userEmail = user?.email;


      final txn = {
      'id': _txnId,
      'date': '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2,'0')}-${_selectedDate.day.toString().padLeft(2,'0')}',
      'type': _type,
      'main_category': _mainCategory,
      'sub_category': _subCategory,
      'description': _description,
      'amount': _amount,
      'fund_source': _fundSource,
      'fund_destination': _fundDestination,
      'fee': _fee,
      'notes': _notes,
      'timestamp': FieldValue.serverTimestamp(), // optional for ordering
      'user_email': userEmail
    };

    try {
      await FirebaseFirestore.instance
          .collection('Transactions')
          .doc(_txnId)
          .set(txn);

      _showMessage('Transaction saved successfully!');
    } catch (e) {
      _showMessage('Failed to save transaction.', success: false);
    }
    } else {
      _showMessage('Please fill all required fields.', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Text('Date'),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2,'0')}-${_selectedDate.day.toString().padLeft(2,'0')}',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Type
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: InputDecoration(labelText: 'Type'),
                  items: _types
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setState(() => _type = val),
                  validator: (val) => val == null ? 'Please select type' : null,
                ),
                SizedBox(height: 16),

                // Main Category
                DropdownButtonFormField<String>(
                  value: _mainCategory,
                  decoration: InputDecoration(labelText: 'Main Category'),
                  items: _mainCategories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() {
                    _mainCategory = val;
                    _subCategory = null;
                  }),
                  validator: (val) => val == null ? 'Please select main category' : null,
                ),
                SizedBox(height: 16),

                // Subcategory
                if (_mainCategory != null)
                  DropdownButtonFormField<String>(
                    value: _subCategory,
                    decoration: InputDecoration(labelText: 'Subcategory'),
                    items: _subCategories[_mainCategory!]!
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setState(() => _subCategory = val),
                    validator: (val) => val == null ? 'Please select subcategory' : null,
                  ),
                SizedBox(height: 16),

                // Description
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (val) => _description = val,
                ),
                SizedBox(height: 16),

                // Amount
                TextFormField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val == null || double.tryParse(val) == null ? 'Enter a valid amount' : null,
                  onSaved: (val) => _amount = double.tryParse(val!),
                ),
                SizedBox(height: 16),

                // Fund Source
                DropdownButtonFormField<String>(
                  value: _fundSource,
                  decoration: InputDecoration(labelText: 'Fund Source'),
                  items: _fundSources
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) => setState(() => _fundSource = val),
                  validator: (val) => val == null ? 'Please select fund source' : null,
                ),
                SizedBox(height: 16),

                // Fund Destination (Transfer only)
                if (_type == 'Transfer')
                  DropdownButtonFormField<String>(
                    value: _fundDestination,
                    decoration: InputDecoration(labelText: 'Fund Destination'),
                    items: _fundDestinations
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (val) => setState(() => _fundDestination = val),
                    validator: (val) =>
                        _type == 'Transfer' && val == null ? 'Please select destination' : null,
                  ),
                SizedBox(height: 16),

                // Fee
                TextFormField(
                  decoration: InputDecoration(labelText: 'Fee (optional)'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => _fee = double.tryParse(val ?? '0'),
                ),
                SizedBox(height: 16),

                // Notes
                TextFormField(
                  decoration: InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                  onSaved: (val) => _notes = val,
                ),
                SizedBox(height: 16),

                // Txn ID
                TextFormField(
                  decoration: InputDecoration(labelText: 'Transaction ID'),
                  onSaved: (val) => _txnId = val,
                ),
                SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Save Transaction'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
