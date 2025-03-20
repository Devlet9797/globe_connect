import 'package:flutter/material.dart';
import '../../../features/auth/view/auth_view.dart';
import '../../../features/auth/view/register_view.dart';
import '../../../features/home/view/home_view.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case '/':
        return _normalNavigate(const AuthView());
      case '/register':
        return _normalNavigate(const RegisterView());
      case '/home':
        return _getRoute(const HomeView());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Sayfa bulunamadı'),
            ),
          ),
        );
    }
  }

  MaterialPageRoute _normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }

  MaterialPageRoute _getRoute(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
    );
  }
}
