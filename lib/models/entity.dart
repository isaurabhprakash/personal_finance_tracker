// TODO: Separate entities into different files (entity_name_model.dart)
class Category {
  String name;

  Category({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
    );
  }
}

class FinancialTransaction {
  final String type; // 'Expenditure', 'Income', 'Self-Transfer'
  final double amount;
  final int fromEntityId;
  final int toEntityId;
  final DateTime date;
  final String description;

  FinancialTransaction({
    required this.type,
    required this.amount,
    required this.fromEntityId,
    required this.toEntityId,
    required this.date,
    required this.description,
  });
}
