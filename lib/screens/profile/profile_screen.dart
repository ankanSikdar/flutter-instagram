import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/profile/widgets/profile_info.dart';
import 'package:instagram_clone/screens/profile/widgets/profile_stats.dart';
import 'package:instagram_clone/widgets/user_profile_image.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthRepository>().logOut();
                  })
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0.0),
                      child: Row(
                        children: [
                          UserProfileImage(
                            radius: 40.0,
                            profileImageUrl: state.user.profileImageUrl,
                          ),
                          ProfileStats(
                            isCurrentUser: state.isCurrentUser,
                            isFollowing: state.isFollowing,
                            posts: 0, // state.posts.length
                            followers: state.user.followers,
                            following: state.user.following,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: ProfileInfo(
                        username: state.user.username,
                        bio: state.user.bio,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
