import 'package:challenge_flutter_ssr/core/error/failures.dart';
import 'package:challenge_flutter_ssr/core/network/dio_client.dart';
import 'package:challenge_flutter_ssr/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:challenge_flutter_ssr/features/posts/data/models/comment_model.dart';
import 'package:challenge_flutter_ssr/features/posts/data/models/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late PostsRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = PostsRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  group('PostsRemoteDataSourceImpl', () {
    group('getPosts', () {
      final tPostsJson = [
        {'id': 1, 'userId': 1, 'title': 'Test Post 1', 'body': 'Test Body 1'},
        {'id': 2, 'userId': 1, 'title': 'Test Post 2', 'body': 'Test Body 2'},
      ];

      test('should return list of PostModel when successful', () async {
        // Arrange
        final response = Response(
          data: tPostsJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts'),
        );
        when(
          () => mockDioClient.get('/posts'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getPosts();

        // Assert
        expect(result, isA<List<PostModel>>());
        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[0].title, 'Test Post 1');
        expect(result[1].id, 2);
        verify(() => mockDioClient.get('/posts')).called(1);
        verifyNoMoreInteractions(mockDioClient);
      });

      test('should return empty list when no posts exist', () async {
        // Arrange
        final response = Response(
          data: [],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts'),
        );
        when(
          () => mockDioClient.get('/posts'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getPosts();

        // Assert
        expect(result, isEmpty);
        expect(result, []);
        verify(() => mockDioClient.get('/posts')).called(1);
      });

      test(
        'should rethrow Failure when DioClient throws NetworkFailure',
        () async {
          // Arrange
          when(
            () => mockDioClient.get('/posts'),
          ).thenThrow(NetworkFailure(message: 'Network error'));

          // Act & Assert
          expect(() => dataSource.getPosts(), throwsA(isA<NetworkFailure>()));
          verify(() => mockDioClient.get('/posts')).called(1);
        },
      );

      test(
        'should rethrow Failure when DioClient throws ServerFailure',
        () async {
          // Arrange
          when(
            () => mockDioClient.get('/posts'),
          ).thenThrow(ServerFailure(message: 'Server error', statusCode: 500));

          // Act & Assert
          expect(() => dataSource.getPosts(), throwsA(isA<ServerFailure>()));
          verify(() => mockDioClient.get('/posts')).called(1);
        },
      );
    });

    group('getPostById', () {
      const tPostId = 1;
      final tPostJson = {
        'id': 1,
        'userId': 1,
        'title': 'Test Post',
        'body': 'Test Body',
      };

      test('should return PostModel when successful', () async {
        // Arrange
        final response = Response(
          data: tPostJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$tPostId'),
        );
        when(
          () => mockDioClient.get('/posts/$tPostId'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getPostById(tPostId);

        // Assert
        expect(result, isA<PostModel>());
        expect(result.id, 1);
        expect(result.title, 'Test Post');
        expect(result.body, 'Test Body');
        verify(() => mockDioClient.get('/posts/$tPostId')).called(1);
        verifyNoMoreInteractions(mockDioClient);
      });

      test('should rethrow Failure when post not found', () async {
        // Arrange
        when(
          () => mockDioClient.get('/posts/$tPostId'),
        ).thenThrow(ServerFailure(message: 'Not found', statusCode: 404));

        // Act & Assert
        expect(
          () => dataSource.getPostById(tPostId),
          throwsA(isA<ServerFailure>()),
        );
        verify(() => mockDioClient.get('/posts/$tPostId')).called(1);
      });

      test('should rethrow Failure when network error occurs', () async {
        // Arrange
        when(
          () => mockDioClient.get('/posts/$tPostId'),
        ).thenThrow(NetworkFailure(message: 'No internet connection'));

        // Act & Assert
        expect(
          () => dataSource.getPostById(tPostId),
          throwsA(isA<NetworkFailure>()),
        );
        verify(() => mockDioClient.get('/posts/$tPostId')).called(1);
      });

      test('should handle different post IDs correctly', () async {
        // Arrange
        const differentPostId = 99;
        final differentPostJson = {
          'id': 99,
          'userId': 5,
          'title': 'Different Post',
          'body': 'Different Body',
        };
        final response = Response(
          data: differentPostJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$differentPostId'),
        );
        when(
          () => mockDioClient.get('/posts/$differentPostId'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getPostById(differentPostId);

        // Assert
        expect(result.id, 99);
        expect(result.userId, 5);
        expect(result.title, 'Different Post');
        verify(() => mockDioClient.get('/posts/$differentPostId')).called(1);
      });
    });

    group('getCommentsByPostId', () {
      const tPostId = 1;
      final tCommentsJson = [
        {
          'id': 1,
          'postId': 1,
          'name': 'John Doe',
          'email': 'john@example.com',
          'body': 'Great post!',
        },
        {
          'id': 2,
          'postId': 1,
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'body': 'Very informative',
        },
      ];

      test('should return list of CommentModel when successful', () async {
        // Arrange
        final response = Response(
          data: tCommentsJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$tPostId/comments'),
        );
        when(
          () => mockDioClient.get('/posts/$tPostId/comments'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getCommentsByPostId(tPostId);

        // Assert
        expect(result, isA<List<CommentModel>>());
        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[0].name, 'John Doe');
        expect(result[0].email, 'john@example.com');
        expect(result[1].id, 2);
        expect(result[1].name, 'Jane Smith');
        verify(() => mockDioClient.get('/posts/$tPostId/comments')).called(1);
        verifyNoMoreInteractions(mockDioClient);
      });

      test('should return empty list when no comments exist', () async {
        // Arrange
        final response = Response(
          data: [],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$tPostId/comments'),
        );
        when(
          () => mockDioClient.get('/posts/$tPostId/comments'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getCommentsByPostId(tPostId);

        // Assert
        expect(result, isEmpty);
        expect(result, []);
        verify(() => mockDioClient.get('/posts/$tPostId/comments')).called(1);
      });

      test(
        'should rethrow Failure when DioClient throws NetworkFailure',
        () async {
          // Arrange
          when(
            () => mockDioClient.get('/posts/$tPostId/comments'),
          ).thenThrow(NetworkFailure(message: 'Network error'));

          // Act & Assert
          expect(
            () => dataSource.getCommentsByPostId(tPostId),
            throwsA(isA<NetworkFailure>()),
          );
          verify(() => mockDioClient.get('/posts/$tPostId/comments')).called(1);
        },
      );

      test('should rethrow Failure when post not found', () async {
        // Arrange
        when(
          () => mockDioClient.get('/posts/$tPostId/comments'),
        ).thenThrow(ServerFailure(message: 'Post not found', statusCode: 404));

        // Act & Assert
        expect(
          () => dataSource.getCommentsByPostId(tPostId),
          throwsA(isA<ServerFailure>()),
        );
        verify(() => mockDioClient.get('/posts/$tPostId/comments')).called(1);
      });

      test('should handle different post IDs correctly', () async {
        // Arrange
        const differentPostId = 5;
        final differentCommentsJson = [
          {
            'id': 10,
            'postId': 5,
            'name': 'Bob Wilson',
            'email': 'bob@example.com',
            'body': 'Nice article',
          },
        ];
        final response = Response(
          data: differentCommentsJson,
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '/posts/$differentPostId/comments',
          ),
        );
        when(
          () => mockDioClient.get('/posts/$differentPostId/comments'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getCommentsByPostId(differentPostId);

        // Assert
        expect(result.length, 1);
        expect(result[0].postId, 5);
        expect(result[0].name, 'Bob Wilson');
        verify(
          () => mockDioClient.get('/posts/$differentPostId/comments'),
        ).called(1);
      });

      test('should handle posts with many comments', () async {
        // Arrange
        final manyCommentsJson = List.generate(
          50,
          (i) => {
            'id': i + 1,
            'postId': tPostId,
            'name': 'User $i',
            'email': 'user$i@example.com',
            'body': 'Comment $i',
          },
        );
        final response = Response(
          data: manyCommentsJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$tPostId/comments'),
        );
        when(
          () => mockDioClient.get('/posts/$tPostId/comments'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getCommentsByPostId(tPostId);

        // Assert
        expect(result.length, 50);
        expect(result.first.id, 1);
        expect(result.last.id, 50);
        verify(() => mockDioClient.get('/posts/$tPostId/comments')).called(1);
      });
    });

    group('Edge cases', () {
      test('should handle post ID 0', () async {
        // Arrange
        const tPostId = 0;
        final tPostJson = {
          'id': 0,
          'userId': 1,
          'title': 'Post Zero',
          'body': 'Body Zero',
        };
        final response = Response(
          data: tPostJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$tPostId'),
        );
        when(
          () => mockDioClient.get('/posts/$tPostId'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getPostById(tPostId);

        // Assert
        expect(result.id, 0);
        verify(() => mockDioClient.get('/posts/$tPostId')).called(1);
      });

      test('should handle large post IDs', () async {
        // Arrange
        const tPostId = 999999;
        final tPostJson = {
          'id': 999999,
          'userId': 1,
          'title': 'Large ID Post',
          'body': 'Large ID Body',
        };
        final response = Response(
          data: tPostJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/$tPostId'),
        );
        when(
          () => mockDioClient.get('/posts/$tPostId'),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getPostById(tPostId);

        // Assert
        expect(result.id, 999999);
        verify(() => mockDioClient.get('/posts/$tPostId')).called(1);
      });
    });
  });
}
