import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bank_account_model.dart';

class BankAccountService {
  static final BankAccountService _instance = BankAccountService._internal();
  factory BankAccountService() => _instance;
  BankAccountService._internal();

  Database? _database;

  // Initialize database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bank_accounts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bank_accounts(
        id TEXT PRIMARY KEY,
        name TEXT,
        accountNumber TEXT,
        bankName TEXT,
        balance REAL,
        accountType TEXT,
        createdAt TEXT
      )
    ''');
  }

  // Create a new bank account
  Future<BankAccount> createBankAccount(BankAccount account) async {
    final db = await database;

    // Generate a unique ID if not provided
    account = account.copyWith(
        id: account.id ?? DateTime.now().millisecondsSinceEpoch.toString());

    // Validate the account
    if (!account.validate()) {
      throw Exception('Invalid bank account details');
    }

    // Insert into database
    await db.insert(
      'bank_accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return account;
  }

  // Retrieve all bank accounts
  Future<List<BankAccount>> getAllBankAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bank_accounts');

    return List.generate(maps.length, (i) {
      return BankAccount.fromMap(maps[i]);
    });
  }

  // Get a specific bank account by ID
  Future<BankAccount?> getBankAccountById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bank_accounts',
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty ? BankAccount.fromMap(maps.first) : null;
  }

  // Update a bank account
  Future<int> updateBankAccount(BankAccount account) async {
    final db = await database;

    // Validate the account
    if (!account.validate()) {
      throw Exception('Invalid bank account details');
    }

    return await db.update(
      'bank_accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  // Delete a bank account
  Future<int> deleteBankAccount(String id) async {
    final db = await database;
    return await db.delete(
      'bank_accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update account balance
  Future<void> updateBalance(String id, double amount) async {
    final account = await getBankAccountById(id);
    if (account != null) {
      final updatedAccount =
          account.copyWith(balance: account.balance + amount);
      await updateBankAccount(updatedAccount);
    }
  }
}
