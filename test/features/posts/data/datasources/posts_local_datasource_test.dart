import 'package:challenge_flutter_ssr/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late PostsLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PostsLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('PostsLocalDataSourceImpl', () {
    group('getLikedPostIds', () {
      test(
        'should return set of liked post IDs from SharedPreferences',
        () async {
          // Arrange
          const tLikedPostsJson = '[1,3,5,7]';
          when(
            () => mockSharedPreferences.getString('liked_posts'),
          ).thenReturn(tLikedPostsJson);

          // Act
          final result = await dataSource.getLikedPostIds();

          // Assert
          expect(result, {1, 3, 5, 7});
          verify(
            () => mockSharedPreferences.getString('liked_posts'),
          ).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test('should return empty set when no data exists', () async {
        // Arrange
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(null);

        // Act
        final result = await dataSource.getLikedPostIds();

        // Assert
        expect(result, isEmpty);
        expect(result, <int>{});
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
      });

      test('should return empty set when JSON decode fails', () async {
        // Arrange
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn('invalid json');

        // Act & Assert
        expect(() => dataSource.getLikedPostIds(), throwsA(isA<Exception>()));
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
      });

      test('should return empty set when exception occurs', () async {
        // Arrange
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => dataSource.getLikedPostIds(), throwsA(isA<Exception>()));
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
      });
    });

    group('toggleLike', () {
      test(
        'should add post ID and return true when post is not liked',
        () async {
          // Arrange
          const tPostId = 1;
          const tExistingLikes = '[2,3]';
          when(
            () => mockSharedPreferences.getString('liked_posts'),
          ).thenReturn(tExistingLikes);
          when(
            () => mockSharedPreferences.setString(any(), any()),
          ).thenAnswer((_) async => true);

          // Act
          final result = await dataSource.toggleLike(tPostId);

          // Assert
          expect(result, true);
          verify(
            () => mockSharedPreferences.getString('liked_posts'),
          ).called(1);
          verify(
            () => mockSharedPreferences.setString('liked_posts', any()),
          ).called(1);
        },
      );

      test(
        'should remove post ID and return false when post is liked',
        () async {
          // Arrange
          const tPostId = 2;
          const tExistingLikes = '[1,2,3]';
          when(
            () => mockSharedPreferences.getString('liked_posts'),
          ).thenReturn(tExistingLikes);
          when(
            () => mockSharedPreferences.setString(any(), any()),
          ).thenAnswer((_) async => true);

          // Act
          final result = await dataSource.toggleLike(tPostId);

          // Assert
          expect(result, false);
          verify(
            () => mockSharedPreferences.getString('liked_posts'),
          ).called(1);
          verify(
            () => mockSharedPreferences.setString('liked_posts', any()),
          ).called(1);
        },
      );

      test('should add first like when no likes exist', () async {
        // Arrange
        const tPostId = 1;
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(null);
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await dataSource.toggleLike(tPostId);

        // Assert
        expect(result, true);
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
        verify(
          () => mockSharedPreferences.setString('liked_posts', '[1]'),
        ).called(1);
      });

      test('should throw exception when setString fails', () async {
        // Arrange
        const tPostId = 1;
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(null);
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenThrow(Exception('Failed to save'));

        // Act & Assert
        expect(() => dataSource.toggleLike(tPostId), throwsA(isA<Exception>()));
      });

      test('should handle multiple toggles correctly', () async {
        // Arrange
        const tPostId = 1;

        // First toggle - like
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(null);
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act - First toggle
        final result1 = await dataSource.toggleLike(tPostId);

        // Assert - First toggle
        expect(result1, true);

        // Second toggle - unlike
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn('[1]');

        // Act - Second toggle
        final result2 = await dataSource.toggleLike(tPostId);

        // Assert - Second toggle
        expect(result2, false);
      });
    });

    group('isPostLiked', () {
      test('should return true when post is liked', () async {
        // Arrange
        const tPostId = 2;
        const tLikedPostsJson = '[1,2,3]';
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(tLikedPostsJson);

        // Act
        final result = await dataSource.isPostLiked(tPostId);

        // Assert
        expect(result, true);
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      });

      test('should return false when post is not liked', () async {
        // Arrange
        const tPostId = 5;
        const tLikedPostsJson = '[1,2,3]';
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(tLikedPostsJson);

        // Act
        final result = await dataSource.isPostLiked(tPostId);

        // Assert
        expect(result, false);
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
      });

      test('should return false when no likes exist', () async {
        // Arrange
        const tPostId = 1;
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(null);

        // Act
        final result = await dataSource.isPostLiked(tPostId);

        // Assert
        expect(result, false);
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
      });

      test('should return false when exception occurs', () async {
        // Arrange
        const tPostId = 1;
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(
          () => dataSource.isPostLiked(tPostId),
          throwsA(isA<Exception>()),
        );
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
      });

      test('should return false when JSON is invalid', () async {
        // Arrange
        const tPostId = 1;
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn('invalid json');

        // Act & Assert
        expect(
          () => dataSource.isPostLiked(tPostId),
          throwsA(isA<Exception>()),
        );
        verify(() => mockSharedPreferences.getString('liked_posts')).called(1);
      });
    });

    group('Edge cases', () {
      test('should handle large numbers of liked posts', () async {
        // Arrange
        final largeLikedList = List.generate(1000, (i) => i);
        final tLikedPostsJson = '[${largeLikedList.join(',')}]';
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(tLikedPostsJson);

        // Act
        final result = await dataSource.getLikedPostIds();

        // Assert
        expect(result.length, 1000);
        expect(result, largeLikedList.toSet());
      });

      test('should handle post ID 0', () async {
        // Arrange
        const tPostId = 0;
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(null);
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await dataSource.toggleLike(tPostId);

        // Assert
        expect(result, true);
        verify(
          () => mockSharedPreferences.setString('liked_posts', '[0]'),
        ).called(1);
      });

      test('should handle negative post IDs', () async {
        // Arrange
        const tPostId = -1;
        when(
          () => mockSharedPreferences.getString('liked_posts'),
        ).thenReturn(null);
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await dataSource.toggleLike(tPostId);

        // Assert
        expect(result, true);
        verify(
          () => mockSharedPreferences.setString('liked_posts', '[-1]'),
        ).called(1);
      });
    });
  });
}
