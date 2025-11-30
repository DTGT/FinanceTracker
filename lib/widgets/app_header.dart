import 'package:financial_tracker/app/views/user_settings/user_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:financial_tracker/app/views/login/login_view.dart';

class AppHeader extends StatelessWidget {
  final Widget child;

  const AppHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Get theme colors and text styles
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final subtitleStyle = theme.textTheme.labelLarge;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          decoration: BoxDecoration(
            color: primaryColor, // pulls from theme
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title + subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Financial Tracker",
                    style: titleStyle?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Manage your finance",
                    style: subtitleStyle?.copyWith(color: Colors.white70),
                  ),
                ],
              ),

              // Profile avatar
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => _profileSheet(context),
                  );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  backgroundColor: Colors.white,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, color: Colors.black)
                      : null,
                ),
              ),
            ],
          ),
        ),

        Expanded(child: child),
      ],
    );
  }

  static Widget _profileSheet(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context); // close bottom sheet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),

          const Divider(),

          ListTile(
            // sign out
            leading: const Icon(Icons.logout),
            title: const Text("Sign out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return; // check widget still exists
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
