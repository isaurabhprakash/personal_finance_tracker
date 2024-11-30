import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/database_helper.dart';
import '../models/entity.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _newCategoryName = '';
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _categories = await DatabaseHelper().getCategories();
    setState(() {});
  }

  Future<void> _addCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Category category = Category(
        name: _newCategoryName,
      );
      await DatabaseHelper().insertCategory(category);
      _loadCategories();
      Navigator.pop(context);
    }
  }

  void _showAddCategoryDialog() {
    _newCategoryName = ''; // Reset category name when opening the dialog

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Form(
            key: _formKey, // Keep the form key here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                  onSaved: (value) =>
                      _newCategoryName = value!, // Save input value
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(onPressed: _addCategory, child: Text('Add')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => {} //_showEditAccountDialog(account),
                    ),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => {} //_deleteBankAccount(account),
                    ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
