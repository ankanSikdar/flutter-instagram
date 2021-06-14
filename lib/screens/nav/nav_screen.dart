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
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (index) {
                final selectedItem = BottomNavItem.values[index];
                context
                    .read<BottomNavBarCubit>()
                    .updateSelectedItem(selectedItem);
              },
            ),
          );
        },
      ),
    );
  }
}
