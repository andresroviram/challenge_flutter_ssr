import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/posts_usecases.dart';
import '../state/posts_state.dart';
import '../providers/posts_providers.dart';

class PostsNotifier extends Notifier<PostsState> {
  @override
  PostsState build() {
    loadPosts();
    return const PostsState();
  }

  PostsUseCase get _useCase => ref.read(postsUseCaseProvider);

  Future<void> loadPosts() async {
    state = state.copyWith(status: PostsStatus.loading);

    final result = await _useCase.getPosts();

    result.fold(
      (failure) => state = state.copyWith(
        status: PostsStatus.error,
        errorMessage: failure.message,
      ),
      (posts) {
        state = state.copyWith(
          status: PostsStatus.success,
          posts: posts,
          filteredPosts: posts,
        );
      },
    );
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }

  void searchPosts(String query) {
    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', filteredPosts: state.posts);
      return;
    }

    final filtered = state.posts.where((post) {
      final titleLower = post.title.toLowerCase();
      final bodyLower = post.body.toLowerCase();
      final queryLower = query.toLowerCase();

      return titleLower.contains(queryLower) || bodyLower.contains(queryLower);
    }).toList();

    state = state.copyWith(searchQuery: query, filteredPosts: filtered);
  }

  void updatePostLike(int postId, bool isLiked) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(isLiked: isLiked);
      }
      return post;
    }).toList();

    final updatedFilteredPosts = state.filteredPosts.map((post) {
      if (post.id == postId) {
        return post.copyWith(isLiked: isLiked);
      }
      return post;
    }).toList();

    state = state.copyWith(
      posts: updatedPosts,
      filteredPosts: updatedFilteredPosts,
    );
  }
}

final postsNotifierProvider = NotifierProvider<PostsNotifier, PostsState>(
  PostsNotifier.new,
);
