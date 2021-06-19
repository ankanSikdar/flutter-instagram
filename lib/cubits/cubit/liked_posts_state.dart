part of 'liked_posts_cubit.dart';

class LikedPostsState extends Equatable {
  final Set<String> likedPostIds;
  final Set<String> recentlyLikedPosts;

  LikedPostsState({
    @required this.likedPostIds,
    @required this.recentlyLikedPosts,
  });

  factory LikedPostsState.initial() {
    return LikedPostsState(likedPostIds: {}, recentlyLikedPosts: {});
  }

  @override
  List<Object> get props => [likedPostIds, recentlyLikedPosts];

  LikedPostsState copyWith({
    Set<String> likedPostIds,
    Set<String> recentlyLikedPosts,
  }) {
    return LikedPostsState(
      likedPostIds: likedPostIds ?? this.likedPostIds,
      recentlyLikedPosts: recentlyLikedPosts ?? this.recentlyLikedPosts,
    );
  }
}
