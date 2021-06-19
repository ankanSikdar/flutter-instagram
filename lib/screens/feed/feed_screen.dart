import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram_clone/screens/profile/widgets/post_view.dart';
import 'package:instagram_clone/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return PostView(post: post, isLiked: false);
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
