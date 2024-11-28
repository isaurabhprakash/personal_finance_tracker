import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'entity.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bank_accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            affect_balance INTEGER,
            balance REAL,
            balance_date TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertBankAccount(BankAccount account) async {
    final db = await database;
    await db.insert('bank_accounts', account.toMap());
  }

  Future<void> updateBankAccount(BankAccount account) async {
    final db = await database;
    await db.update(
      'bank_accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> deleteBankAccount(int id) async {
    final db = await database;
    await db.delete(
      'bank_accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<BankAccount>> getBankAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bank_accounts');
    return List.generate(maps.length, (i) {
      return BankAccount.fromMap(maps[i]);
    });
  }
}
