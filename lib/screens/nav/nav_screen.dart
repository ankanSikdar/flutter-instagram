import 'package:flutter/material.dart';
import 'package:instagram_clone/enums/enums.dart';
import 'package:instagram_clone/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const routeName = "/nav";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (_, __, ___) => NavScreen(),
    );
  }

  final Map<BottomNavItem, IconData> items = {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search_outlined,
    BottomNavItem.create: Icons.add_box_outlined,
    BottomNavItem.notifications: Icons.notifications,
    BottomNavItem.profile: Icons.account_circle_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(
          items: items,
          selectedItem: BottomNavItem.feed,
          onTap: (index) {},
        ),
      ),
    );
  }
}
