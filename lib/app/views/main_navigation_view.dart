import 'package:financial_tracker/app/views/categories/categories.dart';
import 'package:financial_tracker/widgets/app_header.dart';
import 'package:financial_tracker/widgets/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:financial_tracker/app/views/home/home_view.dart';
import 'package:financial_tracker/app/views/transaction_history/transaction_history_view.dart';
import 'package:financial_tracker/app/views/add_transaction/add_transaction_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TransactionHistoryScreen(),
    const HomeScreen(),
    const CategoriesScreen(),
    // const AddTransactionScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // set the height you want
        child: AppHeader(
          child: const SizedBox.shrink(), // child won't be used in appBar
        ),
      ),
      body: _pages[_selectedIndex], // shows the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Categories',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
