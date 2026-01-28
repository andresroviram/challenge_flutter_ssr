import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostsLocalDataSource {
  Future<Set<int>> getLikedPostIds();
  Future<bool> toggleLike(int postId);
  Future<bool> isPostLiked(int postId);
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  static const String _likedPostsKey = 'liked_posts';
  final SharedPreferences sharedPreferences;

  PostsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Set<int>> getLikedPostIds() async {
    try {
      final String? likedPostsJson = sharedPreferences.getString(
        _likedPostsKey,
      );
      if (likedPostsJson == null) {
        return {};
      }
      final List<dynamic> likedPostsList = jsonDecode(likedPostsJson);
      return likedPostsList.map((e) => e as int).toSet();
    } catch (e) {
      throw Exception('Failed to get liked post IDs: $e');
    }
  }

  @override
  Future<bool> toggleLike(int postId) async {
    try {
      final likedPosts = await getLikedPostIds();
      final bool wasLiked = likedPosts.contains(postId);

      if (wasLiked) {
        likedPosts.remove(postId);
      } else {
        likedPosts.add(postId);
      }

      final String likedPostsJson = jsonEncode(likedPosts.toList());
      await sharedPreferences.setString(_likedPostsKey, likedPostsJson);

      return !wasLiked;
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  @override
  Future<bool> isPostLiked(int postId) async {
    try {
      final likedPosts = await getLikedPostIds();
      return likedPosts.contains(postId);
    } catch (e) {
      throw Exception('Failed to check if post is liked: $e');
    }
  }
}
