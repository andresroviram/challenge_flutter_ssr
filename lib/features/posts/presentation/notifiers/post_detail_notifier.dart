import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/posts_usecases.dart';
import '../state/post_detail_state.dart';
import '../providers/posts_providers.dart';
import '../notifiers/posts_notifier.dart';
import '../../../../core/native/notification_service.dart';

class PostDetailNotifier extends Notifier<PostDetailState> {
  final int _postId;

  PostDetailNotifier(this._postId);

  @override
  PostDetailState build() {
    loadPostDetail(_postId);
    return const PostDetailState();
  }

  PostsUseCase get _useCase => ref.read(postsUseCaseProvider);
  NotificationService get _notificationService =>
      ref.read(notificationServiceProvider);

  Future<void> loadPostDetail(int postId) async {
    state = state.copyWith(status: PostDetailStatus.loading);

    final postResult = await _useCase.getPostById(postId);
    final commentsResult = await _useCase.getCommentsByPostId(postId);

    postResult.fold(
      (failure) => state = state.copyWith(
        status: PostDetailStatus.error,
        errorMessage: failure.message,
      ),
      (post) {
        commentsResult.fold(
          (failure) => state = state.copyWith(
            status: PostDetailStatus.error,
            errorMessage: failure.message,
          ),
          (comments) {
            state = state.copyWith(
              status: PostDetailStatus.success,
              post: post,
              comments: comments,
            );
          },
        );
      },
    );
  }

  Future<void> toggleLike() async {
    if (state.post == null || state.isTogglingLike) return;

    state = state.copyWith(isTogglingLike: true);

    final postId = state.post!.id;
    final result = await _useCase.toggleLike(postId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isTogglingLike: false,
          errorMessage: failure.message,
        );
      },
      (newLikeState) {
        final updatedPost = state.post!.copyWith(isLiked: newLikeState);
        state = state.copyWith(post: updatedPost, isTogglingLike: false);

        ref
            .read(postsNotifierProvider.notifier)
            .updatePostLike(postId, newLikeState);

        if (newLikeState) {
          _notificationService.showNotification(
            id: postId.toString(),
            title: 'Te ha gustado',
            message: updatedPost.title,
          );
        }
      },
    );
  }
}

final postDetailNotifierProvider =
    NotifierProvider.family<PostDetailNotifier, PostDetailState, int>(
      (postId) => PostDetailNotifier(postId),
    );
