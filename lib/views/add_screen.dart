import 'package:flutter/material.dart';
import 'sidebar.dart';

// Enum declared at the top level of the file
enum AddItemType { bankAccount, creditCard, category }

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // Add selected index for navigation
  int _selectedIndex = 1; // Default to Add screen

  AddItemType _selectedItemType = AddItemType.bankAccount;
  final _formKey = GlobalKey<FormState>();

  // Controllers for different input fields
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _cardNumberController = TextEditingController();

  // Navigation item tap handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar (Similar to Dashboard)
          SidebarNavigation(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),

          // Main Content
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildItemTypeSelector(),
                      const SizedBox(height: 20),
                      _buildAddItemForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add New Item',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Choose the type of item you want to add',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Item Type Selector
  Widget _buildItemTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildItemTypeButton(
            label: 'Bank Account',
            icon: Icons.account_balance,
            type: AddItemType.bankAccount,
            isSelected: _selectedItemType == AddItemType.bankAccount,
          ),
          const SizedBox(width: 10),
          _buildItemTypeButton(
            label: 'Credit Card',
            icon: Icons.credit_card,
            type: AddItemType.creditCard,
            isSelected: _selectedItemType == AddItemType.creditCard,
          ),
          const SizedBox(width: 10),
          _buildItemTypeButton(
            label: 'Category',
            icon: Icons.category,
            type: AddItemType.category,
            isSelected: _selectedItemType == AddItemType.category,
          ),
        ],
      ),
    );
  }

  // Item Type Button
  Widget _buildItemTypeButton({
    required String label,
    required IconData icon,
    required AddItemType type,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.blue.shade100,
                    Colors.blue.shade200,
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.grey[100]!,
                    Colors.grey[200]!,
                  ],
                ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add Item Form
  Widget _buildAddItemForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[100]!,
            Colors.grey[200]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Common fields
            _buildTextField(
              controller: _nameController,
              label: _getNameLabel(),
              hint: _getNameHint(),
            ),

            // Specific fields based on selected type
            ..._getSpecificFields(),

            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Reusable Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[500]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // Submit Button
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade200,
            Colors.blue.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'Add ${_selectedItemType.toString().split('.').last.capitalize()}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Form Submission Logic
  void _submitForm() {
    // TODO : Create Bank Account Here
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_selectedItemType.toString().split('.').last.capitalize()} Added Successfully!',
          ),
        ),
      );
    }
  }

  // Dynamic Name Label
  String _getNameLabel() {
    switch (_selectedItemType) {
      case AddItemType.bankAccount:
        return 'Account Name';
      case AddItemType.creditCard:
        return 'Card Name';
      case AddItemType.category:
        return 'Category Name';
    }
  }

  // Dynamic Name Hint
  String _getNameHint() {
    switch (_selectedItemType) {
      case AddItemType.bankAccount:
        return 'e.g. Kotak Mahindra Savings Account';
      case AddItemType.creditCard:
        return 'e.g. Personal Credit Card';
      case AddItemType.category:
        return 'e.g. Groceries, Dining Out';
    }
  }

  // Dynamic Additional Fields
  List<Widget> _getSpecificFields() {
    switch (_selectedItemType) {
      case AddItemType.bankAccount:
        return [
          const SizedBox(height: 10),
          _buildTextField(
            controller: _accountNumberController,
            label: 'Account Number',
            hint: 'e.g. 159006444404',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _balanceController,
            label: 'Initial Balance',
            hint: 'Enter initial account balance',
            keyboardType: TextInputType.number,
          ),
        ];
      case AddItemType.creditCard:
        return [
          const SizedBox(height: 10),
          _buildTextField(
            controller: _cardNumberController,
            label: 'Card Number',
            hint: 'Enter last 4 digits',
            keyboardType: TextInputType.number,
          ),
        ];
      case AddItemType.category:
        return []; // No additional fields for category
    }
  }
}

// Extension to capitalize first letter`
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
