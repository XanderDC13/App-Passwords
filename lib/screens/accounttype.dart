import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SelectAccountTypeScreen extends StatelessWidget {
  const SelectAccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountTypes = [
      {'name': 'Facebook', 'icon': LucideIcons.facebook},
      {'name': 'Gmail', 'icon': LucideIcons.mail},
      {'name': 'Instagram', 'icon': LucideIcons.instagram},
      {'name': 'Twitter', 'icon': LucideIcons.twitter},
      {'name': 'Email', 'icon': LucideIcons.atSign},
      {'name': 'Wi-Fi', 'icon': LucideIcons.wifi},
      {'name': 'Bank', 'icon': LucideIcons.creditCard},
      {'name': 'Netflix', 'icon': LucideIcons.tv},
      {'name': 'Spotify', 'icon': LucideIcons.music},
      {'name': 'Amazon', 'icon': LucideIcons.shoppingCart},
      {'name': 'GitHub', 'icon': LucideIcons.github},
      {'name': 'Steam', 'icon': LucideIcons.gamepad2},
      {'name': 'YouTube', 'icon': LucideIcons.youtube},
      {'name': 'LinkedIn', 'icon': LucideIcons.briefcase},
      {'name': 'Outlook', 'icon': LucideIcons.mailCheck},
      {'name': 'Dropbox', 'icon': LucideIcons.folderOpen},
      {'name': 'Otros', 'icon': LucideIcons.moreHorizontal},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Account Type')),
      body: ListView.builder(
        itemCount: accountTypes.length,
        itemBuilder: (context, index) {
          final item = accountTypes[index];
          return ListTile(
            leading: Icon(item['icon'] as IconData),
            title: Text(item['name'] as String),
            onTap: () => Navigator.pop(context, item['name']),
          );
        },
      ),
    );
  }
}
