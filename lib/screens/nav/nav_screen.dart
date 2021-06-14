import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/enums/enums.dart';
import 'package:instagram_clone/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:instagram_clone/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const routeName = "/nav";

  static Route route() {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      transitionDuration: Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (context) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  /* 
  Defining Navigator Keys to maintain the current Navigator State for 
  each one of our bottom Nav Items
  */
  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKey = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search_outlined,
    BottomNavItem.create: Icons.add_box_outlined,
    BottomNavItem.notifications: Icons.notifications,
    BottomNavItem.profile: Icons.account_circle_outlined,
  };

  void _selectBottomNavItem(
      {BuildContext context, BottomNavItem selectedItem, bool isSameItem}) {
    if (isSameItem) {
      /* 
      If the user taps on the currently selected Item then we pop them back 
      to the first route in the navigation stack
      */
      navigatorKey[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffStageNavigator({BottomNavItem currentItem, bool isSelected}) {
    return Offstage(
      offstage: !isSelected, // Hides child when true, Shows child when false
      child: TabNavigator(
        item: currentItem,
        navigatorKey: navigatorKey[currentItem],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            /*
            Stack so we can render all the screens and make sure we save the
            current navigation state for each of the screens
            */
            body: Stack(
              children: items
                  .map(
                    (item, icon) => MapEntry(
                      item,
                      _buildOffStageNavigator(
                        currentItem: item,
                        isSelected: item == state.selectedItem,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (index) {
                final selectedItem = BottomNavItem.values[index];
                _selectBottomNavItem(
                  context: context,
                  selectedItem: selectedItem,
                  isSameItem: selectedItem == state.selectedItem,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
