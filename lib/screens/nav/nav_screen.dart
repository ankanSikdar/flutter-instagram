import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  static const routeName = "/nav";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (_, __, ___) => NavScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('Nav Screen'),
      ),
    );
  }
}
