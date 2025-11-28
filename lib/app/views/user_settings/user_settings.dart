import 'package:flutter/material.dart';
import 'package:financial_tracker/widgets/app_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppHeader(
      child: Center(
        child: Text("User Settings"),
      ),
    );
  }

  
}
