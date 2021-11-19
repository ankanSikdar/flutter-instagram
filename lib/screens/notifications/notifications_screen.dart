import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/screens/notifications/bloc/notifications_bloc.dart';
import 'package:instagram_clone/screens/notifications/widgets/widgets.dart';
import 'package:instagram_clone/widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationStatus.error:
              return CenteredText(text: state.failure.message);
            case NotificationStatus.loaded:
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  Notif notification = state.notifications[index];
                  return Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      child: NotificationTile(notificaiton: notification));
                },
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
