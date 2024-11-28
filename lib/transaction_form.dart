import 'package:flutter/material.dart';
import 'entity.dart';

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  Entity? _sender;
  Entity? _receiver;
  double _amount = 0.0;
  String _notes = '';
  DateTime _selectedDate = DateTime.now();

  List<Entity> entities = [
    Entity('Bank Account 1', true),
    Entity('Credit Card 1', true),
    Entity('Savings - FD', false),
    Entity('Cash', true),
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_sender!.affectBalance) {
        print('Deducting $_amount from ${_sender!.name}');
      }
      if (_receiver!.affectBalance) {
        print('Adding $_amount to ${_receiver!.name}');
      }

      // Save transaction logic goes here.
      Navigator.pop(context);
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<Entity>(
                value: _sender,
                items: entities.map((entity) {
                  return DropdownMenuItem(
                    value: entity,
                    child: Text(entity.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _sender = value),
                decoration: InputDecoration(labelText: 'Sender'),
                validator: (value) => value == null ? 'Select a sender' : null,
              ),
              DropdownButtonFormField<Entity>(
                value: _receiver,
                items: entities.map((entity) {
                  return DropdownMenuItem(
                    value: entity,
                    child: Text(entity.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _receiver = value),
                decoration: InputDecoration(labelText: 'Receiver'),
                validator: (value) =>
                    value == null ? 'Select a receiver' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              Row(
                children: [
                  Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (value) => _notes = value ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Entity {
  String name;
  bool affectBalance;

  Entity(this.name, this.affectBalance);
}
