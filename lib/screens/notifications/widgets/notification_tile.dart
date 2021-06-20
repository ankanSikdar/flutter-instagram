import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/enums/enums.dart';
import 'package:instagram_clone/models/notif_model.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:instagram_clone/widgets/user_profile_image.dart';
import 'package:instagram_clone/extensions/datetime_extension.dart';

class NotificationTile extends StatelessWidget {
  final Notif notificaiton;

  const NotificationTile({
    Key key,
    @required this.notificaiton,
  }) : super(key: key);

  String _getText(Notif notificaiton) {
    switch (notificaiton.type) {
      case NotifType.like:
        return 'liked your post.';
      case NotifType.comment:
        return 'commented on your post';
      case NotifType.follow:
        return 'started following you.';
      default:
        return '';
    }
  }

  _getTrailing(BuildContext context, Notif notificaiton) {
    if (notificaiton.type == NotifType.like ||
        notificaiton.type == NotifType.comment) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            CommentsScreen.routeName,
            arguments: CommentsScreenArgs(post: notificaiton.post),
          );
        },
        child: CachedNetworkImage(
          height: 60.0,
          width: 60.0,
          fit: BoxFit.cover,
          imageUrl: notificaiton.post.imageUrl,
        ),
      );
    } else if (notificaiton.type == NotifType.follow) {
      return SizedBox(
        height: 60.0,
        width: 60.0,
        child: Icon(Icons.person_add),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfileImage(
        profileImageUrl: notificaiton.fromUser.profileImageUrl,
        radius: 18.0,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: notificaiton.fromUser.username,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: ' '),
            TextSpan(text: _getText(notificaiton))
          ],
        ),
      ),
      trailing: _getTrailing(context, notificaiton),
      subtitle: Text(
        notificaiton.date.timeAgo(),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          ProfileScreen.routeName,
          arguments: ProfileScreenArgs(
            userId: notificaiton.fromUser.id,
          ),
        );
      },
    );
  }
}
