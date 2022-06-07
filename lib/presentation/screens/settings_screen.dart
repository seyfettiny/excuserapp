import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pushNamed(context, '/privacy_policy');
            },
          )
        ],
      ),
    );
  }
}
