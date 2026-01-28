import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';

enum PostsStatus { initial, loading, success, error }

class PostsState extends Equatable {
  final PostsStatus status;
  final List<PostEntity> posts;
  final List<PostEntity> filteredPosts;
  final String searchQuery;
  final String? errorMessage;

  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.filteredPosts = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  PostsState copyWith({
    PostsStatus? status,
    List<PostEntity>? posts,
    List<PostEntity>? filteredPosts,
    String? searchQuery,
    String? errorMessage,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      filteredPosts: filteredPosts ?? this.filteredPosts,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    filteredPosts,
    searchQuery,
    errorMessage,
  ];
}
