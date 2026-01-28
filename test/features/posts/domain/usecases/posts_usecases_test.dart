import 'package:challenge_flutter_ssr/core/error/failures.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/entities/comment_entity.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/entities/post_entity.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/repositories/posts_repository.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/usecases/posts_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late PostsUseCase useCase;
  late MockPostsRepository mockRepository;

  setUp(() {
    mockRepository = MockPostsRepository();
    useCase = PostsUseCase(mockRepository);
  });

  group('PostsUseCase', () {
    group('getPosts', () {
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

      test('should return list of posts from repository', () async {
        // Arrange
        when(
          () => mockRepository.getPosts(),
        ).thenAnswer((_) async => Right(tPosts));

        // Act
        final result = await useCase.getPosts();

        // Assert
        expect(result, Right(tPosts));
        verify(() => mockRepository.getPosts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return failure when repository fails', () async {
        // Arrange
        final tFailure = NetworkFailure(message: 'Network error');
        when(
          () => mockRepository.getPosts(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase.getPosts();

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.getPosts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('getPostById', () {
      const tPostId = 1;
      const tPost = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test Body',
        isLiked: false,
      );

      test('should return post from repository', () async {
        // Arrange
        when(
          () => mockRepository.getPostById(tPostId),
        ).thenAnswer((_) async => const Right(tPost));

        // Act
        final result = await useCase.getPostById(tPostId);

        // Assert
        expect(result, const Right(tPost));
        verify(() => mockRepository.getPostById(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return failure when post not found', () async {
        // Arrange
        final tFailure = NetworkFailure(message: 'Post not found');
        when(
          () => mockRepository.getPostById(tPostId),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase.getPostById(tPostId);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.getPostById(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('getCommentsByPostId', () {
      const tPostId = 1;
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

      test('should return list of comments from repository', () async {
        // Arrange
        when(
          () => mockRepository.getCommentsByPostId(tPostId),
        ).thenAnswer((_) async => Right(tComments));

        // Act
        final result = await useCase.getCommentsByPostId(tPostId);

        // Assert
        expect(result, Right(tComments));
        verify(() => mockRepository.getCommentsByPostId(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return failure when repository fails', () async {
        // Arrange
        final tFailure = NetworkFailure(message: 'Failed to load comments');
        when(
          () => mockRepository.getCommentsByPostId(tPostId),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase.getCommentsByPostId(tPostId);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.getCommentsByPostId(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('toggleLike', () {
      const tPostId = 1;

      test('should return true when post is liked', () async {
        // Arrange
        when(
          () => mockRepository.toggleLike(tPostId),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase.toggleLike(tPostId);

        // Assert
        expect(result, const Right(true));
        verify(() => mockRepository.toggleLike(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return false when post is unliked', () async {
        // Arrange
        when(
          () => mockRepository.toggleLike(tPostId),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase.toggleLike(tPostId);

        // Assert
        expect(result, const Right(false));
        verify(() => mockRepository.toggleLike(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return failure when toggle fails', () async {
        // Arrange
        final tFailure = CacheFailure(message: 'Failed to toggle like');
        when(
          () => mockRepository.toggleLike(tPostId),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase.toggleLike(tPostId);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.toggleLike(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('isPostLiked', () {
      const tPostId = 1;

      test('should return true when post is liked', () async {
        // Arrange
        when(
          () => mockRepository.isPostLiked(tPostId),
        ).thenAnswer((_) async => const Right(true));

        // Act
        final result = await useCase.isPostLiked(tPostId);

        // Assert
        expect(result, const Right(true));
        verify(() => mockRepository.isPostLiked(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return false when post is not liked', () async {
        // Arrange
        when(
          () => mockRepository.isPostLiked(tPostId),
        ).thenAnswer((_) async => const Right(false));

        // Act
        final result = await useCase.isPostLiked(tPostId);

        // Assert
        expect(result, const Right(false));
        verify(() => mockRepository.isPostLiked(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return failure when check fails', () async {
        // Arrange
        final tFailure = CacheFailure(message: 'Failed to check like status');
        when(
          () => mockRepository.isPostLiked(tPostId),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase.isPostLiked(tPostId);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.isPostLiked(tPostId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('getLikedPostIds', () {
      final tLikedIds = {1, 3, 5, 7};

      test('should return set of liked post IDs', () async {
        // Arrange
        when(
          () => mockRepository.getLikedPostIds(),
        ).thenAnswer((_) async => Right(tLikedIds));

        // Act
        final result = await useCase.getLikedPostIds();

        // Assert
        expect(result, Right(tLikedIds));
        verify(() => mockRepository.getLikedPostIds()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return empty set when no posts are liked', () async {
        // Arrange
        when(
          () => mockRepository.getLikedPostIds(),
        ).thenAnswer((_) async => const Right(<int>{}));

        // Act
        final result = await useCase.getLikedPostIds();

        // Assert
        expect(result, const Right(<int>{}));
        verify(() => mockRepository.getLikedPostIds()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return failure when retrieval fails', () async {
        // Arrange
        final tFailure = CacheFailure(message: 'Failed to get liked posts');
        when(
          () => mockRepository.getLikedPostIds(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await useCase.getLikedPostIds();

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.getLikedPostIds()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
