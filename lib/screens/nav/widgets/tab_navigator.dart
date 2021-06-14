import 'package:flutter/material.dart';

import 'package:instagram_clone/enums/enums.dart';
import 'package:instagram_clone/screens/feed/feed_screen.dart';
import 'package:instagram_clone/screens/screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);

  Map<String, WidgetBuilder> _routeBuilders() {
    return {
      tabNavigatorRoot: (context) => _getScreen(context: context, item: item)
    };
  }

  Widget _getScreen({BuildContext context, BottomNavItem item}) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.create:
        return CreatePostScreen();
      case BottomNavItem.notifications:
        return NotificationsScreen();
      case BottomNavItem.profile:
        return ProfileScreen();
      default:
        return Scaffold();
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();

    //Creates a widget that maintains a stack-based history of child widgets.
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute](context))
        ];
      },
    );
  }
}
