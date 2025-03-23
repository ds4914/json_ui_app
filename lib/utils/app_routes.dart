import 'package:flutter/material.dart';
import 'package:jsonuiapp/screens/dynamic_ui_screen.dart';

class AppRoutes {
  static const String login = "login";
  static const String dashboard = "dashboard";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => DynamicUIScreen(screenName: 'login'),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => DynamicUIScreen(screenName: 'dashboard'),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => DynamicUIScreen(screenName: settings.name ?? "login"),
        );
    }
  }
}
