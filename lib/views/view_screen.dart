import 'package:flutter/material.dart';
import 'sidebar.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  int _selectedIndex = 2; // Set to 2 to highlight the View section

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
          // Sidebar Navigation
          SidebarNavigation(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),

          // Main Content
          Expanded(
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  _buildViewCategories(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // App Bar similar to Dashboard
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      expandedHeight: 80,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage Your Finances',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // View Categories Section
  SliverToBoxAdapter _buildViewCategories(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5, // Adjusted to make boxes smaller
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildCategoryCard(
                  context,
                  icon: Icons.account_balance,
                  label: 'Bank Accounts',
                  color: Colors.blueAccent,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BankAccountsListScreen(),
                      ),
                    );
                  },
                ),
                _buildCategoryCard(
                  context,
                  icon: Icons.credit_card,
                  label: 'Credit Cards',
                  color: Colors.greenAccent,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreditCardsListScreen(),
                      ),
                    );
                  },
                ),
                _buildCategoryCard(
                  context,
                  icon: Icons.category,
                  label: 'Categories',
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CategoriesListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Category Card Widget
  Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30), // Reduced icon size
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14, // Reduced font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder Screens for Navigation
class BankAccountsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Accounts'),
      ),
      body: ListView(
        children: [
          _buildAccountItem('Checking Account', '\$5,420.25'),
          _buildAccountItem('Savings Account', '\$15,000.00'),
        ],
      ),
    );
  }

  Widget _buildAccountItem(String name, String balance) {
    return ListTile(
      title: Text(name),
      trailing: Text(
        balance,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CreditCardsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Cards'),
      ),
      body: ListView(
        children: [
          _buildCreditCardItem('Visa Card', '\$2,340.50'),
          _buildCreditCardItem('Master Card', '\$1,205.75'),
        ],
      ),
    );
  }

  Widget _buildCreditCardItem(String name, String balance) {
    return ListTile(
      title: Text(name),
      trailing: Text(
        balance,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }
}

class CategoriesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Categories'),
      ),
      body: ListView(
        children: [
          _buildCategoryItem('Groceries', '\$350.25'),
          _buildCategoryItem('Dining Out', '\$220.50'),
          _buildCategoryItem('Transportation', '\$180.75'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, String totalSpent) {
    return ListTile(
      title: Text(name),
      trailing: Text(
        totalSpent,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
