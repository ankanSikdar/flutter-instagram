import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/blocs/blocs.dart';
import 'package:instagram_clone/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  //! Work-Around as BlocListener is not working here.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          false, //Restricts the Users ability to pop the screen
      child: BlocBuilder<AuthBloc, AuthState>(
        // Prevent listener from triggering if status did not change
        buildWhen: (previousState, currentState) =>
            previousState.status != currentState.status,
        builder: (context, state) {
          if (state.status == AuthStatus.unauthenticated ||
              state.status == AuthStatus.unknown) {
            return LoginScreen();
          } else if (state.status == AuthStatus.authenticated) {
            return NavScreen();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async =>
//           false, //Restricts the Users ability to pop the screen
//       child: BlocListener<AuthBloc, AuthState>(
//         // Prevent listener from triggering if status did not change
//         listenWhen: (previousState, currentState) =>
//             previousState.status != currentState.status,
//         listener: (context, state) {
//           if (state.status == AuthStatus.unauthenticated) {
//             return Navigator.of(context).pushNamed(LoginScreen.routeName);
//           } else if (state.status == AuthStatus.authenticated) {
//             return Navigator.of(context).pushNamed(NavScreen.routeName);
//           }
//         },
//         child: Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     );
//   }
