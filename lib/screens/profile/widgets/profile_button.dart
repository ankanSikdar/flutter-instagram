import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/screens.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProfile.routeName,
                arguments: EditProfileScreenArgs(context: context),
              );
            },
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0),
            ),
          )
        : isFollowing
            ? OutlinedButton(
                onPressed: () {
                  context.read<ProfileBloc>().add(ProfileUnfollowUser());
                },
                child: Text(
                  'Unfollow',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  context.read<ProfileBloc>().add(ProfileFollowUser());
                },
                child: Text(
                  'Follow',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
  }
}
