import 'package:flutter/material.dart';
import 'transaction_screen.dart'; // Import the transaction screen
import 'package:intl/intl.dart'; // Import the intl package to format date
import 'bank_accounts.dart'; // Import the Bank Accounts screen

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current date
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Finance Tracker'),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Bank Accounts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BankAccountsScreen()), // Navigate to Bank Accounts
                );
              },
            ),
            // Add any other items for navigation if needed
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to your Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.blueGrey[700], // Set background color of the bottom bar
        height: 120, // Increase the height a bit to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formattedDate, // Show the current date
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10), // Add some space between date and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Expense Button
                  IconButton(
                    icon: Icon(Icons.money_off), // Icon for Expense
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransactionScreen(mode: 'Expenditure'),
                        ),
                      );
                    },
                    color: Colors.white, // Icon color
                  ),
                  // Income Button
                  IconButton(
                    icon: Icon(Icons.attach_money), // Icon for Income
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransactionScreen(mode: 'Income'),
                        ),
                      );
                    },
                    color: Colors.white, // Icon color
                  ),
                  // Self-Transfer Button
                  IconButton(
                    icon: Icon(Icons.compare_arrows), // Icon for Self-Transfer
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransactionScreen(mode: 'Self-Transfer'),
                        ),
                      );
                    },
                    color: Colors.white, // Icon color
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
