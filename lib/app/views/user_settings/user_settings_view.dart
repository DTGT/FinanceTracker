import 'package:financial_tracker/app/viewmodels/user_settings_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final userSettings = UserSettingsViewModel();

  @override
  void initState() {
    super.initState();
    userSettings.loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: userSettings,
      child: Consumer<UserSettingsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Example fields
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(viewModel.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final TextEditingController controller =
                            TextEditingController(
                              text: viewModel.userSettings?.name ?? '',
                            );

                        final newName = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Edit Name'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: 'Enter new name',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, null),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, controller.text),
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );

                        if (newName != null &&
                            newName.isNotEmpty &&
                            newName != viewModel.name) {
                          await viewModel.editUserName(newName);
                          // Optionally show feedback
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Name updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(viewModel.email),
                  ),
                  ListTile(
                    title: const Text('Currency'),
                    subtitle: Text(viewModel.currency),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Implement currency selection
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
