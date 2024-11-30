import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/views/dashboard.dart';
import 'package:personal_finance_tracker/views/add_screen.dart';
import 'package:personal_finance_tracker/views/view_screen.dart';

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const SidebarNavigation(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[100]!,
            Colors.grey[200]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(1, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSidebarItem(
            context: context,
            icon: Icons.home,
            label: 'Home',
            index: 0,
          ),
          _buildSidebarItem(
            context: context,
            icon: Icons.add,
            label: 'Add',
            index: 1,
          ),
          _buildSidebarItem(
            context: context,
            icon: Icons.view_agenda,
            label: 'View',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _navigateToScreen(context, index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.blue.shade100,
                    Colors.blue.shade200,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    // Prevent navigating to the same screen
    if (selectedIndex == index) {
      return;
    }

    // Call the onItemTapped callback to update the selected index
    onItemTapped(index);

    // Navigate to the corresponding screen
    switch (index) {
      case 0: // Home screen (Dashboard)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
        break;
      case 1: // Add screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddScreen()),
        );
        break;
      case 2: // View screen (Expenses)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewScreen()),
        );
        break;
    }
  }
}
