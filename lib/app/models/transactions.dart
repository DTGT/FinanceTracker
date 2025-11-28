import 'package:cloud_firestore/cloud_firestore.dart';


class TransactionModel {
  String id;
  DateTime date;
  String type;
  String mainCategory;
  String? subCategory;
  String? description;
  double amount;
  String fundSource;
  String? fundDestination;
  double? fee;
  String? notes;
  String userEmail;

  TransactionModel({
    required this.id,
    required this.date,
    required this.type,
    required this.mainCategory,
    this.subCategory,
    this.description,
    required this.amount,
    required this.fundSource,
    this.fundDestination,
    this.fee,
    this.notes,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}',
    'type': type,
    'main_category': mainCategory,
    'sub_category': subCategory,
    'description': description,
    'amount': amount,
    'fund_source': fundSource,
    'fund_destination': fundDestination,
    'fee': fee,
    'notes': notes,
    'timestamp': FieldValue.serverTimestamp(),
    'user_email': userEmail,
  };

   factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      date: map['date'] is Timestamp
            ? (map['date'] as Timestamp).toDate()
            : DateTime.parse(map['date'] as String),
      type: map['type'] ?? '',
      mainCategory: map['main_category'] ?? '',
      subCategory: map['sub_category'],
      description: map['description'],
      amount: (map['amount'] as num).toDouble(),
      fundSource: map['fund_source'] ?? '',
      fundDestination: map['fund_destination'],
      fee: map['fee'] != null ? (map['fee'] as num).toDouble() : null,
      notes: map['notes'],
      userEmail: map['user_email'] ?? '',
    );
  }

}
