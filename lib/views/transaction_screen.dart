import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/entity.dart';

abstract class BaseTransactionScreen extends StatefulWidget {
  final String mode;
  const BaseTransactionScreen({required this.mode});

  @override
  BaseTransactionScreenState createState();
}

abstract class BaseTransactionScreenState<T extends BaseTransactionScreen>
    extends State<T> {
  String? _fromEntity;
  String? _toEntity;
  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String _description = '';

  List<BankAccount> _bankAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadBankAccounts();
  }

  Future<void> _loadBankAccounts() async {
    _bankAccounts = await DatabaseHelper().getBankAccounts();
    setState(() {});
  }

  List<DropdownMenuItem<String>> getFromEntityItems();
  List<DropdownMenuItem<String>> getToEntityItems();

  Future<void> _submitTransaction() async {
    if (_fromEntity == null || _toEntity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both 'From' and 'To' entities")),
      );
      return;
    }

    FinancialTransaction transaction = FinancialTransaction(
      type: widget.mode,
      amount: _amount,
      fromEntityId: int.parse(_fromEntity!),
      toEntityId: int.parse(_toEntity!),
      date: _date,
      description: _description,
    );

    await DatabaseHelper().insertTransaction(transaction);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select Date: ${_date.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 18),
              ),
            ),
            DropdownButton<String>(
              value: _fromEntity,
              hint: Text("From Entity"),
              items: getFromEntityItems(),
              onChanged: (value) {
                setState(() {
                  _fromEntity = value;
                });
              },
            ),
            DropdownButton<String>(
              value: _toEntity,
              hint: Text("To Entity"),
              items: getToEntityItems(),
              onChanged: (value) {
                setState(() {
                  _toEntity = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Description"),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class SelfTransferScreen extends BaseTransactionScreen {
  SelfTransferScreen() : super(mode: 'Self-Transfer');

  @override
  _SelfTransferScreenState createState() => _SelfTransferScreenState();
}

class _SelfTransferScreenState
    extends BaseTransactionScreenState<SelfTransferScreen> {
  @override
  List<DropdownMenuItem<String>> getFromEntityItems() {
    return _bankAccounts.map((ba) {
      return DropdownMenuItem<String>(
        value: ba.id.toString(),
        child: Text(ba.name),
      );
    }).toList();
  }

  @override
  List<DropdownMenuItem<String>> getToEntityItems() {
    return _bankAccounts.map((ba) {
      return DropdownMenuItem<String>(
        value: ba.id.toString(),
        child: Text(ba.name),
      );
    }).toList();
  }
}

class IncomeScreen extends BaseTransactionScreen {
  IncomeScreen() : super(mode: 'Income');

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends BaseTransactionScreenState<IncomeScreen> {
  @override
  List<DropdownMenuItem<String>> getFromEntityItems() => [];

  @override
  List<DropdownMenuItem<String>> getToEntityItems() {
    return _bankAccounts.map((ba) {
      return DropdownMenuItem<String>(
        value: ba.id.toString(),
        child: Text(ba.name),
      );
    }).toList();
  }
}

class ExpensesScreen extends BaseTransactionScreen {
  ExpensesScreen() : super(mode: 'Expenditure');

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends BaseTransactionScreenState<ExpensesScreen> {
  @override
  List<DropdownMenuItem<String>> getFromEntityItems() {
    return _bankAccounts.map((ba) {
      return DropdownMenuItem<String>(
        value: ba.id.toString(),
        child: Text(ba.name),
      );
    }).toList();
  }

  @override
  List<DropdownMenuItem<String>> getToEntityItems() {
    return _bankAccounts.map((e) {
      return DropdownMenuItem<String>(
        value: e.id.toString(),
        child: Text(e.name),
      );
    }).toList();
  }
}
