import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:instagram_clone/blocs/blocs.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:instagram_clone/repositories/repositories.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Comment>>> _commentsSubscription;

  CommentsBloc({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : this._postRepository = postRepository,
        this._authBloc = authBloc,
        super(CommentsState.initial());

  @override
  Future<void> close() {
    _commentsSubscription.cancel();
    super.close();
  }

  @override
  Stream<CommentsState> mapEventToState(
    CommentsEvent event,
  ) async* {
    if (event is CommentsFetchComments) {
      yield* _mapCommentsFetchCommentsToState(event);
    } else if (event is CommentsUpdateComments) {
      yield* _mapCommentsUpdateCommentsToState(event);
    } else if (event is CommentsPostComment) {
      yield* _mapCommentsPostCommentToState(event);
    }
  }

  Stream<CommentsState> _mapCommentsFetchCommentsToState(
      CommentsFetchComments event) async* {
    yield state.copyWith(status: CommentStatus.loading);
    try {
      _commentsSubscription?.cancel();
      _commentsSubscription = _postRepository
          .getPostComments(postId: event.post.id)
          .listen((comments) async {
        final allComments = await Future.wait(comments);
        add(CommentsUpdateComments(comments: allComments));
      });

      yield state.copyWith(status: CommentStatus.loaded, post: event.post);
    } catch (error) {
      yield state.copyWith(
          status: CommentStatus.error,
          failure: Failure(message: 'We are unable to load comments.'));
    }
  }

  Stream<CommentsState> _mapCommentsUpdateCommentsToState(
      CommentsUpdateComments event) async* {
    yield state.copyWith(comments: event.comments);
  }

  Stream<CommentsState> _mapCommentsPostCommentToState(
      CommentsPostComment event) async* {
    yield state.copyWith(status: CommentStatus.submitting);
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final comment = Comment(
        author: author,
        content: event.content,
        postId: state.post.id,
        date: DateTime.now(),
      );

      await _postRepository.createComment(post: state.post, comment: comment);

      yield state.copyWith(status: CommentStatus.loaded);
    } catch (error) {
      yield state.copyWith(
          status: CommentStatus.error,
          failure: Failure(message: 'We are unable to post the comment.'));
    }
  }
}
