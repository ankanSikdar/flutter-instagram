import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route :${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          // For seeing what page the use is accessing in Analytics
          settings: RouteSettings(name: '/'),
          builder: (_) => Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SignUpScreen.routeName:
        return SignUpScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('ERROR'),
        ),
        body: Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
