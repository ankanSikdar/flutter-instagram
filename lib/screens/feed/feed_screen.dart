import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/cubits/cubit/liked_posts_cubit.dart';
import 'package:instagram_clone/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram_clone/screens/profile/widgets/post_view.dart';
import 'package:instagram_clone/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        if (state.posts.isEmpty) {
          return CenteredText(text: 'No Posts To Show.');
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              final likedPostState = context.watch<LikedPostsCubit>().state;
              final isLiked = likedPostState.likedPostIds.contains(post.id);
              final recentlyLiked =
                  likedPostState.recentlyLikedPosts.contains(post.id);
              return PostView(
                post: post,
                isLiked: isLiked,
                recentlyLiked: recentlyLiked,
                onLike: () {
                  if (isLiked) {
                    context.read<LikedPostsCubit>().unlikePost(post: post);
                  } else {
                    context.read<LikedPostsCubit>().likePost(post: post);
                  }
                },
              );
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        } else if (state.status == FeedStatus.paginating) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fetching more posts...'),
              duration: Duration(seconds: 1),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Instagram'),
            actions: [
              if (state.posts.isEmpty && state.status == FeedStatus.loaded)
                IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      context.read<FeedBloc>().add(FeedFetchPosts());
                    })
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }
}
