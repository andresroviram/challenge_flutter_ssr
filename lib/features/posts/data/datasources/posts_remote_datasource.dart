import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_response_extensions.dart';
import '../../../../core/error/failures.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPostById(int id);
  Future<List<CommentModel>> getCommentsByPostId(int postId);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final DioClient dioClient;

  PostsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await dioClient.get('/posts');
      return response.withListConverter(callback: PostModel.fromJson);
    } on Failure catch (_) {
      rethrow;
    }
  }

  @override
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await dioClient.get('/posts/$id');
      return response.withConverter(callback: PostModel.fromJson);
    } on Failure catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> getCommentsByPostId(int postId) async {
    try {
      final response = await dioClient.get('/posts/$postId/comments');
      return response.withListConverter(callback: CommentModel.fromJson);
    } on Failure catch (_) {
      rethrow;
    }
  }
}
