import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;

  const ProfileStats({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
    @required this.posts,
    @required this.followers,
    @required this.following,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stats(count: posts, label: 'Posts'),
              _Stats(count: followers, label: 'Followers'),
              _Stats(count: following, label: 'Following'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final int count;
  final String label;

  const _Stats({
    Key key,
    @required this.count,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.black54),
        )
      ],
    );
  }
}
