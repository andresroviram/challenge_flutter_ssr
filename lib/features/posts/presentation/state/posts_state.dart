import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post_entity.dart';

part 'posts_state.freezed.dart';

@freezed
class PostsState with _$PostsState {
  const factory PostsState.initial() = PostsInitial;
  const factory PostsState.loading() = PostsLoading;
  const factory PostsState.success({
    required List<PostEntity> posts,
    @Default(<PostEntity>[]) List<PostEntity> filteredPosts,
    @Default('') String searchQuery,
  }) = PostsSuccess;
  const factory PostsState.error(String message) = PostsError;
}
