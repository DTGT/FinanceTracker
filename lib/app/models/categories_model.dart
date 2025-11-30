class IncomeCategoryModel {
  String userId;
  String incomeName;

  IncomeCategoryModel({required this.userId, required this.incomeName});

  Map<String, dynamic> toMap() => {'user_id': userId, 'category': incomeName};

  factory IncomeCategoryModel.fromMap(Map<String, dynamic> map) {
    return IncomeCategoryModel(
      userId: map['user_id'] ?? '',
      incomeName: map['category'] ?? '',
    );
  }
}

class ExpenseCategoryModel {
  String userId;
  String expenseName;
  String category;

  ExpenseCategoryModel({
    required this.userId,
    required this.expenseName,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'expense_name': expenseName,
    'category': category,
  };

  factory ExpenseCategoryModel.fromMap(Map<String, dynamic> map) {
    return ExpenseCategoryModel(
      userId: map['user_id'] ?? '',
      expenseName: map['expense_name'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
