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

  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route :${settings.name}');
    switch (settings.name) {
      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments);
      case EditProfile.routeName:
        return EditProfile.route(args: settings.arguments);
      case CommentsScreen.routeName:
        return CommentsScreen.route(args: settings.arguments);
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
