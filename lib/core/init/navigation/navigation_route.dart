import 'package:flutter/material.dart';
import '../../../features/auth/view/auth_view.dart';
import '../../../features/home/view/home_view.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case '/':
      case '/auth':
        return _getRoute(const AuthView());
      case '/home':
        return _getRoute(const HomeView());
      default:
        return _getRoute(const AuthView());
    }
  }

  MaterialPageRoute _getRoute(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
    );
  }
}
