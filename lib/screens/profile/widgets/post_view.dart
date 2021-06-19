import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/screens/profile/profile_screen.dart';
import 'package:instagram_clone/widgets/user_profile_image.dart';
import 'package:instagram_clone/extensions/datetime_extension.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  const PostView({
    Key key,
    @required this.post,
    @required this.isLiked,
    @required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProfileScreen.routeName,
                arguments: ProfileScreenArgs(userId: post.author.id),
              );
            },
            child: Row(
              children: [
                UserProfileImage(
                    radius: 18.0, profileImageUrl: post.author.profileImageUrl),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    post.author.username,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: onLike,
          child: CachedNetworkImage(
            height: MediaQuery.of(context).size.height / 2.25,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: post.imageUrl,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: isLiked
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.favorite_outline_rounded,
                    ),
              onPressed: onLike,
            ),
            IconButton(
              icon: Icon(Icons.comment_outlined),
              onPressed: () {},
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${recentlyLiked ? post.likes + 1 : post.likes} likes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: post.author.username,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    TextSpan(text: ' '),
                    TextSpan(
                      text: post.caption,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                post.date.timeAgo(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
