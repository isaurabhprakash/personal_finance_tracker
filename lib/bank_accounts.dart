import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class BankAccountsScreen extends StatefulWidget {
  @override
  _BankAccountsScreenState createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _balanceController = TextEditingController();
  bool _affectBalance = true;
  String _newAccountName = '';
  String _balanceDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  double _balance = 0.0;
  FocusNode _balanceFocusNode = FocusNode();

  List<BankAccount> _bankAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadBankAccounts();

    _balanceFocusNode.addListener(() {
      if (_balanceFocusNode.hasFocus && _balanceController.text == '0.0') {
        _balanceController.clear(); // Clears if balance is initially 0.0
      }
    });
  }

  Future<void> _loadBankAccounts() async {
    _bankAccounts = await DatabaseHelper().getBankAccounts();
    setState(() {});
  }

  void _showAddAccountDialog() {
    _newAccountName = '';
    _balanceController.text = '0.0';
    _affectBalance = true;
    _balanceDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Bank Account'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Account Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a name' : null,
                      onSaved: (value) => _newAccountName = value!,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _affectBalance,
                          onChanged: (value) {
                            setDialogState(() {
                              _affectBalance = value!;
                            });
                          },
                        ),
                        Text('Affect Balance'),
                      ],
                    ),
                    TextFormField(
                      focusNode: _balanceFocusNode,
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Initial Balance'),
                      onSaved: (value) {
                        _balance = double.tryParse(value ?? '0') ?? 0.0;
                      },
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context, setDialogState),
                      child: Text('Select Balance Date'),
                    ),
                    Text('Selected Date: ${_balanceDate.split('T').first}'),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(onPressed: _addBankAccount, child: Text('Add')),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, StateSetter setDialogState) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setDialogState(() {
        _balanceDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _addBankAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BankAccount account = BankAccount(
        name: _newAccountName,
        balance: _balance,
        balanceDate: _balanceDate,
        affectBalance: _affectBalance,
      );
      await DatabaseHelper().insertBankAccount(account);
      _loadBankAccounts();
      Navigator.pop(context);
    }
  }

  void _showEditAccountDialog(BankAccount account) {
    _newAccountName = account.name;
    _balanceController.text = account.balance.toString();
    _affectBalance = account.affectBalance;
    _balanceDate = account.balanceDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Bank Account'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: _newAccountName,
                      decoration: InputDecoration(labelText: 'Account Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a name' : null,
                      onSaved: (value) => _newAccountName = value!,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _affectBalance,
                          onChanged: (value) {
                            setDialogState(() {
                              _affectBalance = value!;
                            });
                          },
                        ),
                        Text('Affect Balance'),
                      ],
                    ),
                    TextFormField(
                      focusNode: _balanceFocusNode,
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Initial Balance'),
                      onSaved: (value) {
                        _balance = double.tryParse(value ?? '0') ?? 0.0;
                      },
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context, setDialogState),
                      child: Text('Select Balance Date'),
                    ),
                    Text('Selected Date: ${_balanceDate.split('T').first}'),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () => _editBankAccount(account),
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editBankAccount(BankAccount account) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      account.name = _newAccountName;
      account.balance = _balance;
      account.balanceDate = _balanceDate;
      account.affectBalance = _affectBalance;
      await DatabaseHelper().updateBankAccount(account);
      _loadBankAccounts();
      Navigator.pop(context);
    }
  }

  Future<void> _deleteBankAccount(BankAccount account) async {
    await DatabaseHelper().deleteBankAccount(account.id!);
    _loadBankAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Accounts'),
      ),
      body: ListView.builder(
        itemCount: _bankAccounts.length,
        itemBuilder: (context, index) {
          final account = _bankAccounts[index];
          return ListTile(
            title: Text(account.name),
            subtitle: Text(
                'Balance: ${account.balance} (Date: ${account.balanceDate})'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditAccountDialog(account),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteBankAccount(account),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAccountDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
