import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/comment_entity.dart';

part 'post_detail_state.freezed.dart';

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState.initial() = PostDetailInitial;
  const factory PostDetailState.loading() = PostDetailLoading;
  const factory PostDetailState.success({
    required PostEntity post,
    required List<CommentEntity> comments,
    @Default(false) bool isTogglingLike,
  }) = PostDetailSuccess;
  const factory PostDetailState.error(String message) = PostDetailError;
}
