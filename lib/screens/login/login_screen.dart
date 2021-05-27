import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (_, __, ___) => LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('Login Screen'),
      ),
    );
  }
}
