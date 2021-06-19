import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/blocs/blocs.dart';

import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/comments/bloc/comments_bloc.dart';
import 'package:instagram_clone/widgets/widgets.dart';

class CommentsScreenArgs {
  final Post post;
  CommentsScreenArgs({@required this.post});
}

class CommentsScreen extends StatefulWidget {
  static const String routeName = "/comments";

  static Route route({@required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (_) => CommentsBloc(
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(CommentsFetchComments(post: args.post)),
        child: CommentsScreen(),
      ),
    );
  }

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Comments'),
          ),
          body: ListView.builder(
              padding: EdgeInsets.only(bottom: 60.0),
              itemCount: state.comments.length,
              itemBuilder: (context, index) {
                final comment = state.comments[index];
                return ListTile(
                  leading: UserProfileImage(
                    radius: 22.0,
                    profileImageUrl: comment.author.profileImageUrl,
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: comment.author.username,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' '),
                        TextSpan(text: comment.content)
                      ],
                    ),
                  ),
                );
              }),
          bottomSheet: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == CommentStatus.submitting)
                  LinearProgressIndicator(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentsController,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Add a comment'),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          final content = _commentsController.text.trim();
                          if (content.length > 1 &&
                              state.status != CommentStatus.submitting) {
                            context
                                .read<CommentsBloc>()
                                .add(CommentsPostComment(content: content));
                            _commentsController.clear();
                          }
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
