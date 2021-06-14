import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const String routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Click'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('New Page'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
