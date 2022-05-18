import 'package:drift/drift.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:excuserapp/features/excuse/presentation/screens/settings_screen.dart';
import 'package:excuserapp/features/excuse/presentation/widgets/privacy_policy_widget.dart';
import 'package:flutter/material.dart';

class MyRouter {
  MyRouter._internal();
  static final instance = MyRouter._internal();
  factory MyRouter() => instance;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/dbViewer':
        return MaterialPageRoute(
          builder: (_) =>
              DriftDbViewer(settings.arguments as GeneratedDatabase),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case '/privacy_policy':
        return MaterialPageRoute(
          builder: (_) => PrivacyPolicyWidget(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
