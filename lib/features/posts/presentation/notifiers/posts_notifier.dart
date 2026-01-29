import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/posts_usecases.dart';
import '../state/posts_state.dart';
import '../providers/posts_providers.dart';

class PostsNotifier extends Notifier<PostsState> {
  @override
  PostsState build() {
    loadPosts();
    return const PostsState.initial();
  }

  PostsUseCase get _useCase => ref.read(postsUseCaseProvider);

  Future<void> loadPosts() async {
    state = const PostsState.loading();

    final result = await _useCase.getPosts();

    result.fold(
      (failure) => state = PostsState.error(failure.message),
      (posts) => state = PostsState.success(posts: posts, filteredPosts: posts),
    );
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }

  void searchPosts(String query) {
    state.maybeWhen(
      success: (posts, filteredPosts, searchQuery) {
        if (query.isEmpty) {
          state = PostsState.success(
            posts: posts,
            filteredPosts: posts,
            searchQuery: '',
          );
          return;
        }

        final filtered = posts.where((post) {
          final titleLower = post.title.toLowerCase();
          final bodyLower = post.body.toLowerCase();
          final queryLower = query.toLowerCase();

          return titleLower.contains(queryLower) ||
              bodyLower.contains(queryLower);
        }).toList();

        state = PostsState.success(
          posts: posts,
          filteredPosts: filtered,
          searchQuery: query,
        );
      },
      orElse: () {},
    );
  }

  void updatePostLike(int postId, bool isLiked) {
    state.maybeWhen(
      success: (posts, filteredPosts, searchQuery) {
        final updatedPosts = posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(isLiked: isLiked);
          }
          return post;
        }).toList();

        final updatedFilteredPosts = filteredPosts.map((post) {
          if (post.id == postId) {
            return post.copyWith(isLiked: isLiked);
          }
          return post;
        }).toList();

        state = PostsState.success(
          posts: updatedPosts,
          filteredPosts: updatedFilteredPosts,
          searchQuery: searchQuery,
        );
      },
      orElse: () {},
    );
  }
}

final postsNotifierProvider = NotifierProvider<PostsNotifier, PostsState>(
  PostsNotifier.new,
);
