import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/entities.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();

  Future<Either<Failure, PostEntity>> getPostById(int id);

  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(int postId);

  Future<Either<Failure, bool>> toggleLike(int postId);

  Future<Either<Failure, bool>> isPostLiked(int postId);

  Future<Either<Failure, Set<int>>> getLikedPostIds();
}
