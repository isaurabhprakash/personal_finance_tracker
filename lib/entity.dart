class BankAccount {
  int? id;
  String name;
  bool affectBalance;
  double balance;
  String balanceDate;

  BankAccount({
    this.id,
    required this.name,
    required this.affectBalance,
    required this.balance,
    required this.balanceDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'affect_balance': affectBalance ? 1 : 0,
      'balance': balance,
      'balance_date': balanceDate,
    };
  }

  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      id: map['id'],
      name: map['name'],
      affectBalance: map['affect_balance'] == 1,
      balance: map['balance'],
      balanceDate: map['balance_date'],
    );
  }
}

class Entity {
  final int id;
  final String name;
  final bool affectsBalance;

  Entity({required this.id, required this.name, required this.affectsBalance});
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
