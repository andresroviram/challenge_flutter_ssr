import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/post_entity.dart';
import '../entities/comment_entity.dart';
import '../repositories/posts_repository.dart';

class PostsUseCase {
  PostsUseCase(this.repository);

  final PostsRepository repository;

  Future<Either<Failure, List<PostEntity>>> getPosts() {
    return repository.getPosts();
  }

  Future<Either<Failure, PostEntity>> getPostById(int id) {
    return repository.getPostById(id);
  }

  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(int postId) {
    return repository.getCommentsByPostId(postId);
  }

  Future<Either<Failure, bool>> toggleLike(int postId) {
    return repository.toggleLike(postId);
  }

  Future<Either<Failure, bool>> isPostLiked(int postId) {
    return repository.isPostLiked(postId);
  }

  Future<Either<Failure, Set<int>>> getLikedPostIds() {
    return repository.getLikedPostIds();
  }
}
