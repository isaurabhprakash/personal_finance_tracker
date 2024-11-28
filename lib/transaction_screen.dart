import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'entity.dart';

class TransactionScreen extends StatefulWidget {
  final String mode; // 'Expenditure', 'Income', 'Self-Transfer'

  TransactionScreen({required this.mode});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String? _fromEntity;
  String? _toEntity;
  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String _description = '';
  List<Entity> _entities = [];

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  _loadEntities() async {
    _entities = await DatabaseHelper().getEntities();
    setState(() {});
  }

  _submitTransaction() async {
    if (_fromEntity == null || _toEntity == null) {
      // Handle error if "from" or "to" entities are not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both 'From' and 'To' entities")),
      );
      return;
    }

    // Here, you can save your transaction data to the database
    FinancialTransaction transaction = FinancialTransaction(
      type: widget.mode,
      amount: _amount,
      fromEntityId: _fromEntity!.isNotEmpty ? int.parse(_fromEntity!) : 0,
      toEntityId: _toEntity!.isNotEmpty ? int.parse(_toEntity!) : 0,
      date: _date,
      description: _description,
    );
    await DatabaseHelper().insertTransaction(transaction);
    Navigator.pop(context);
  }

  _selectDate(BuildContext context) async {
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
            // Date Picker for selecting date
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Select Date: ${_date.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 18),
              ),
            ),

            // From Entity Dropdown
            DropdownButton<String>(
              value: _fromEntity,
              hint: Text("From Entity"),
              items: _entities
                  .map((e) => DropdownMenuItem<String>(
                        value: e.id.toString(),
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _fromEntity = value;
                });
              },
            ),

            // To Entity Dropdown
            DropdownButton<String>(
              value: _toEntity,
              hint: Text("To Entity"),
              items: _entities
                  .map((e) => DropdownMenuItem<String>(
                        value: e.id.toString(),
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _toEntity = value;
                });
              },
            ),

            // Amount input
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0.0;
                });
              },
            ),

            // Description input
            TextField(
              decoration: InputDecoration(labelText: "Description"),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),

            // Submit button
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
