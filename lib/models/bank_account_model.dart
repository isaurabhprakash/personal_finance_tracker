class BankAccount {
  String? id;
  String name;
  String accountNumber;
  double balance;

  BankAccount({
    this.id,
    required this.name,
    required this.accountNumber,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      id: map['id'],
      name: map['name'],
      accountNumber: map['accountNumber'],
      balance: map['balance'],
    );
  }

  // Method to create a copy with optional updates
  BankAccount copyWith({
    String? id,
    String? name,
    String? accountNumber,
    double? balance,
  }) {
    return BankAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
    );
  }

  // Validation method
  bool validate() {
    return name.isNotEmpty;
  }
}
