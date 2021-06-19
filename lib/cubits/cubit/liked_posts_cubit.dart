import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/models/models.dart';
import 'package:meta/meta.dart';

import 'package:instagram_clone/blocs/blocs.dart';
import 'package:instagram_clone/repositories/repositories.dart';

part 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  LikedPostsCubit({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : this._postRepository = postRepository,
        this._authBloc = authBloc,
        super(LikedPostsState.initial());

  void updateLikedPosts({@required Set<String> postIds}) {
    emit(state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds)));
  }

  void likePost({@required Post post}) {
    _postRepository.createLike(post: post, userId: _authBloc.state.user.uid);

    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id),
        recentlyLikedPosts: Set<String>.from(state.recentlyLikedPosts)
          ..add(post.id),
      ),
    );
  }

  void unlikePost({@required Post post}) {
    _postRepository.deleteLike(
      postId: post.id,
      userId: _authBloc.state.user.uid,
    );

    emit(state.copyWith(
      likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id),
      recentlyLikedPosts: Set<String>.from(state.recentlyLikedPosts)
        ..remove(post.id),
    ));
  }

  void clearAllLikedPost() {
    emit(LikedPostsState.initial());
  }
}
