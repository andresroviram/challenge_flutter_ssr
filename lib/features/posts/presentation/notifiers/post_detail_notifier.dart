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
    return const PostDetailState.initial();
  }

  PostsUseCase get _useCase => ref.read(postsUseCaseProvider);
  NotificationService get _notificationService =>
      ref.read(notificationServiceProvider);

  Future<void> loadPostDetail(int postId) async {
    state = const PostDetailState.loading();

    final postResult = await _useCase.getPostById(postId);
    final commentsResult = await _useCase.getCommentsByPostId(postId);

    postResult.fold(
      (failure) => state = PostDetailState.error(failure.message),
      (post) {
        commentsResult.fold(
          (failure) => state = PostDetailState.error(failure.message),
          (comments) {
            state = PostDetailState.success(post: post, comments: comments);
          },
        );
      },
    );
  }

  Future<void> toggleLike() async {
    state.maybeWhen(
      success: (post, comments, isTogglingLike) async {
        if (isTogglingLike) return;

        state = PostDetailState.success(
          post: post,
          comments: comments,
          isTogglingLike: true,
        );

        final postId = post.id;
        final result = await _useCase.toggleLike(postId);

        result.fold(
          (failure) {
            state = PostDetailState.success(
              post: post,
              comments: comments,
              isTogglingLike: false,
            );
            // Opcional: podrías usar un estado de error si prefieres
          },
          (newLikeState) {
            final updatedPost = post.copyWith(isLiked: newLikeState);
            state = PostDetailState.success(
              post: updatedPost,
              comments: comments,
              isTogglingLike: false,
            );

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
      },
      orElse: () {},
    );
  }
}

final postDetailNotifierProvider =
    NotifierProvider.family<PostDetailNotifier, PostDetailState, int>(
      (postId) => PostDetailNotifier(postId),
    );
