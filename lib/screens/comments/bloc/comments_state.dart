part of 'comments_bloc.dart';

enum CommentStatus { initial, loading, loaded, submitting, error }

class CommentsState extends Equatable {
  final Post post;
  final List<Comment> comments;
  final CommentStatus status;
  final Failure failure;

  CommentsState({
    @required this.post,
    @required this.comments,
    @required this.status,
    @required this.failure,
  });

  factory CommentsState.initial() {
    return CommentsState(
      post: null,
      comments: [],
      status: CommentStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        post,
        comments,
        status,
        failure,
      ];

  CommentsState copyWith({
    Post post,
    List<Comment> comments,
    CommentStatus status,
    Failure failure,
  }) {
    return CommentsState(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
