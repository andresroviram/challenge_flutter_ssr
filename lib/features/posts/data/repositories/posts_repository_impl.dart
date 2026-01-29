import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/entities/comment_entity.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';
import '../datasources/posts_local_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      final postModels = await remoteDataSource.getPosts();
      final likedPostIds = await localDataSource.getLikedPostIds();

      final posts = postModels
          .map(
            (model) => model.toEntity(isLiked: likedPostIds.contains(model.id)),
          )
          .toList();
      return Right(posts);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById(int id) async {
    try {
      final postModel = await remoteDataSource.getPostById(id);
      final isLiked = await localDataSource.isPostLiked(id);

      return Right(postModel.toEntity(isLiked: isLiked));
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(
    int postId,
  ) async {
    try {
      final commentModels = await remoteDataSource.getCommentsByPostId(postId);
      final comments = commentModels.map((model) => model.toEntity()).toList();

      return Right(comments);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> toggleLike(int postId) async {
    try {
      final newLikeState = await localDataSource.toggleLike(postId);
      return Right(newLikeState);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isPostLiked(int postId) async {
    try {
      final isLiked = await localDataSource.isPostLiked(postId);
      return Right(isLiked);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Set<int>>> getLikedPostIds() async {
    try {
      final likedIds = await localDataSource.getLikedPostIds();
      return Right(likedIds);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
