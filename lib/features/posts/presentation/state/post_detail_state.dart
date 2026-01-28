import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/comment_entity.dart';

enum PostDetailStatus { initial, loading, success, error }

class PostDetailState extends Equatable {
  final PostDetailStatus status;
  final PostEntity? post;
  final List<CommentEntity> comments;
  final String? errorMessage;
  final bool isTogglingLike;

  const PostDetailState({
    this.status = PostDetailStatus.initial,
    this.post,
    this.comments = const [],
    this.errorMessage,
    this.isTogglingLike = false,
  });

  PostDetailState copyWith({
    PostDetailStatus? status,
    PostEntity? post,
    List<CommentEntity>? comments,
    String? errorMessage,
    bool? isTogglingLike,
  }) {
    return PostDetailState(
      status: status ?? this.status,
      post: post ?? this.post,
      comments: comments ?? this.comments,
      errorMessage: errorMessage ?? this.errorMessage,
      isTogglingLike: isTogglingLike ?? this.isTogglingLike,
    );
  }

  @override
  List<Object?> get props => [
    status,
    post,
    comments,
    errorMessage,
    isTogglingLike,
  ];
}
