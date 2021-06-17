import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';

import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/profile/widgets/profile_info.dart';
import 'package:instagram_clone/screens/profile/widgets/profile_stats.dart';
import 'package:instagram_clone/widgets/error_dialog.dart';
import 'package:instagram_clone/widgets/user_profile_image.dart';

class ProfileScreenArgs {
  final String userId;
  ProfileScreenArgs({
    @required this.userId,
  });
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        Widget _buildBody() {
          switch (state.status) {
            case ProfileStatus.loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileLoadUser(userId: state.user.id));
                  return true;
                },
                child: CustomScrollView(
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
                                  posts: state.posts.length,
                                  followers: state.user.followers,
                                  following: state.user.following,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 10.0,
                            ),
                            child: ProfileInfo(
                              username: state.user.username,
                              bio: state.user.bio,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorWeight: 3.0,
                        onTap: (index) {
                          context.read<ProfileBloc>().add(
                              ProfileToggleGridView(isGridView: index == 0));
                        },
                        tabs: [
                          Tab(icon: Icon(Icons.grid_on, size: 28.0)),
                          Tab(icon: Icon(Icons.list, size: 28.0)),
                        ],
                      ),
                    ),
                    state.isGridView
                        ? SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 2.0,
                              crossAxisSpacing: 2.0,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final post = state.posts[index];
                                return GestureDetector(
                                  onTap: () {},
                                  child: CachedNetworkImage(
                                    imageUrl: post.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              childCount: state.posts.length,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final post = state.posts[index];
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  height: 100.0,
                                  width: double.infinity,
                                  color: Colors.red,
                                );
                              },
                              childCount: state.posts.length,
                            ),
                          ),
                  ],
                ),
              );
          }
        }

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
          body: _buildBody(),
        );
      },
    );
  }
}
