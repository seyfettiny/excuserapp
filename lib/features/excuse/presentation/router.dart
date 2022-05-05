import 'package:drift/drift.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
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
