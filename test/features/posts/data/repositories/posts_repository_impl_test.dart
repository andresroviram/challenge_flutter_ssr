import 'package:challenge_flutter_ssr/core/error/failures.dart';
import 'package:challenge_flutter_ssr/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:challenge_flutter_ssr/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:challenge_flutter_ssr/features/posts/data/models/comment_model.dart';
import 'package:challenge_flutter_ssr/features/posts/data/models/post_model.dart';
import 'package:challenge_flutter_ssr/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/entities/comment_entity.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRemoteDataSource extends Mock implements PostsRemoteDataSource {}

class MockPostsLocalDataSource extends Mock implements PostsLocalDataSource {}

void main() {
  late PostsRepositoryImpl repository;
  late MockPostsRemoteDataSource mockRemoteDataSource;
  late MockPostsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPostsRemoteDataSource();
    mockLocalDataSource = MockPostsLocalDataSource();
    repository = PostsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('PostsRepositoryImpl', () {
    group('getPosts', () {
      final tPostModels = [
        const PostModel(
          id: 1,
          userId: 1,
          title: 'Test Post 1',
          body: 'Test Body 1',
        ),
        const PostModel(
          id: 2,
          userId: 1,
          title: 'Test Post 2',
          body: 'Test Body 2',
        ),
      ];

      final tLikedPostIds = {2};

      final tPosts = [
        const PostEntity(
          id: 1,
          userId: 1,
          title: 'Test Post 1',
          body: 'Test Body 1',
          isLiked: false,
        ),
        const PostEntity(
          id: 2,
          userId: 1,
          title: 'Test Post 2',
          body: 'Test Body 2',
          isLiked: true,
        ),
      ];

      test(
        'should return list of posts with correct like status when successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPosts(),
          ).thenAnswer((_) async => tPostModels);
          when(
            () => mockLocalDataSource.getLikedPostIds(),
          ).thenAnswer((_) async => tLikedPostIds);

          // Act
          final result = await repository.getPosts();

          // Assert
          expect(result.isRight(), true);
          result.fold((failure) => fail('Should not return failure'), (posts) {
            expect(posts, tPosts);
            expect(posts[0].isLiked, false);
            expect(posts[1].isLiked, true);
          });
          verify(() => mockRemoteDataSource.getPosts()).called(1);
          verify(() => mockLocalDataSource.getLikedPostIds()).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test('should return Failure when remote data source fails', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getPosts(),
        ).thenThrow(NetworkFailure(message: 'Network error'));

        // Act
        final result = await repository.getPosts();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<Failure>()),
          (posts) => fail('Should not return posts'),
        );
        verify(() => mockRemoteDataSource.getPosts()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test(
        'should return posts with no likes when local data source fails',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getPosts(),
          ).thenAnswer((_) async => tPostModels);
          when(
            () => mockLocalDataSource.getLikedPostIds(),
          ).thenThrow(Exception('Cache error'));

          // Act
          final result = await repository.getPosts();

          // Assert
          expect(result.isLeft(), true);
          verify(() => mockRemoteDataSource.getPosts()).called(1);
          verify(() => mockLocalDataSource.getLikedPostIds()).called(1);
        },
      );
    });

    group('getPostById', () {
      const tPostId = 1;
      const tPostModel = PostModel(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test Body',
      );

      const tPostEntityLiked = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test Body',
        isLiked: true,
      );

      const tPostEntityNotLiked = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test Body',
        isLiked: false,
      );

      test('should return post with liked status when successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getPostById(tPostId),
        ).thenAnswer((_) async => tPostModel);
        when(
          () => mockLocalDataSource.isPostLiked(tPostId),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.getPostById(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (post) {
          expect(post, tPostEntityLiked);
          expect(post.isLiked, true);
        });
        verify(() => mockRemoteDataSource.getPostById(tPostId)).called(1);
        verify(() => mockLocalDataSource.isPostLiked(tPostId)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return post with not liked status when not liked', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getPostById(tPostId),
        ).thenAnswer((_) async => tPostModel);
        when(
          () => mockLocalDataSource.isPostLiked(tPostId),
        ).thenAnswer((_) async => false);

        // Act
        final result = await repository.getPostById(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (post) {
          expect(post, tPostEntityNotLiked);
          expect(post.isLiked, false);
        });
        verify(() => mockRemoteDataSource.getPostById(tPostId)).called(1);
        verify(() => mockLocalDataSource.isPostLiked(tPostId)).called(1);
      });

      test('should return Failure when remote data source fails', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getPostById(tPostId),
        ).thenThrow(NetworkFailure(message: 'Post not found'));

        // Act
        final result = await repository.getPostById(tPostId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<Failure>()),
          (post) => fail('Should not return post'),
        );
        verify(() => mockRemoteDataSource.getPostById(tPostId)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });

    group('getCommentsByPostId', () {
      const tPostId = 1;
      final tCommentModels = [
        const CommentModel(
          id: 1,
          postId: 1,
          name: 'John Doe',
          email: 'john@example.com',
          body: 'Great post!',
        ),
        const CommentModel(
          id: 2,
          postId: 1,
          name: 'Jane Smith',
          email: 'jane@example.com',
          body: 'Very informative',
        ),
      ];

      final tComments = [
        const CommentEntity(
          id: 1,
          postId: 1,
          name: 'John Doe',
          email: 'john@example.com',
          body: 'Great post!',
        ),
        const CommentEntity(
          id: 2,
          postId: 1,
          name: 'Jane Smith',
          email: 'jane@example.com',
          body: 'Very informative',
        ),
      ];

      test('should return list of comments when successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getCommentsByPostId(tPostId),
        ).thenAnswer((_) async => tCommentModels);

        // Act
        final result = await repository.getCommentsByPostId(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (comments) => expect(comments, tComments),
        );
        verify(
          () => mockRemoteDataSource.getCommentsByPostId(tPostId),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return Failure when remote data source fails', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getCommentsByPostId(tPostId),
        ).thenThrow(NetworkFailure(message: 'Failed to load comments'));

        // Act
        final result = await repository.getCommentsByPostId(tPostId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<Failure>()),
          (comments) => fail('Should not return comments'),
        );
        verify(
          () => mockRemoteDataSource.getCommentsByPostId(tPostId),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return empty list when no comments exist', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getCommentsByPostId(tPostId),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getCommentsByPostId(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (comments) {
          expect(comments, isEmpty);
          expect(comments, []);
        });
        verify(
          () => mockRemoteDataSource.getCommentsByPostId(tPostId),
        ).called(1);
      });
    });

    group('toggleLike', () {
      const tPostId = 1;

      test('should return true when post is newly liked', () async {
        // Arrange
        when(
          () => mockLocalDataSource.toggleLike(tPostId),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.toggleLike(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (isLiked) => expect(isLiked, true),
        );
        verify(() => mockLocalDataSource.toggleLike(tPostId)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return false when post is unliked', () async {
        // Arrange
        when(
          () => mockLocalDataSource.toggleLike(tPostId),
        ).thenAnswer((_) async => false);

        // Act
        final result = await repository.toggleLike(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (isLiked) => expect(isLiked, false),
        );
        verify(() => mockLocalDataSource.toggleLike(tPostId)).called(1);
      });

      test('should return CacheFailure when local data source fails', () async {
        // Arrange
        when(
          () => mockLocalDataSource.toggleLike(tPostId),
        ).thenThrow(Exception('Failed to toggle like'));

        // Act
        final result = await repository.toggleLike(tPostId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (isLiked) => fail('Should not return success'),
        );
        verify(() => mockLocalDataSource.toggleLike(tPostId)).called(1);
      });
    });

    group('isPostLiked', () {
      const tPostId = 1;

      test('should return true when post is liked', () async {
        // Arrange
        when(
          () => mockLocalDataSource.isPostLiked(tPostId),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.isPostLiked(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (isLiked) => expect(isLiked, true),
        );
        verify(() => mockLocalDataSource.isPostLiked(tPostId)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return false when post is not liked', () async {
        // Arrange
        when(
          () => mockLocalDataSource.isPostLiked(tPostId),
        ).thenAnswer((_) async => false);

        // Act
        final result = await repository.isPostLiked(tPostId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (isLiked) => expect(isLiked, false),
        );
        verify(() => mockLocalDataSource.isPostLiked(tPostId)).called(1);
      });

      test('should return CacheFailure when local data source fails', () async {
        // Arrange
        when(
          () => mockLocalDataSource.isPostLiked(tPostId),
        ).thenThrow(Exception('Failed to check like status'));

        // Act
        final result = await repository.isPostLiked(tPostId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (isLiked) => fail('Should not return success'),
        );
        verify(() => mockLocalDataSource.isPostLiked(tPostId)).called(1);
      });
    });

    group('getLikedPostIds', () {
      final tLikedIds = {1, 3, 5, 7};

      test('should return set of liked post IDs when successful', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getLikedPostIds(),
        ).thenAnswer((_) async => tLikedIds);

        // Act
        final result = await repository.getLikedPostIds();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (likedIds) => expect(likedIds, tLikedIds),
        );
        verify(() => mockLocalDataSource.getLikedPostIds()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return empty set when no posts are liked', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getLikedPostIds(),
        ).thenAnswer((_) async => <int>{});

        // Act
        final result = await repository.getLikedPostIds();

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (likedIds) {
          expect(likedIds, isEmpty);
          expect(likedIds, <int>{});
        });
        verify(() => mockLocalDataSource.getLikedPostIds()).called(1);
      });

      test('should return CacheFailure when local data source fails', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getLikedPostIds(),
        ).thenThrow(Exception('Failed to get liked posts'));

        // Act
        final result = await repository.getLikedPostIds();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (likedIds) => fail('Should not return success'),
        );
        verify(() => mockLocalDataSource.getLikedPostIds()).called(1);
      });
    });
  });
}
