import 'package:flutter/material.dart';
import 'package:financial_tracker/widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppHeader(
      child: Center(
        child: Text("Home Screen"),
      ),
    );
  }

  
}
