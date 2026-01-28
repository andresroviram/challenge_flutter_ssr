import 'package:challenge_flutter_ssr/features/posts/data/models/post_model.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostModel', () {
    const tPostModel = PostModel(
      id: 1,
      userId: 10,
      title: 'Test Post Title',
      body: 'Test post body content',
    );

    final tPostJson = {
      'id': 1,
      'userId': 10,
      'title': 'Test Post Title',
      'body': 'Test post body content',
    };

    group('fromJson', () {
      test('should return a valid PostModel from JSON', () {
        // Act
        final result = PostModel.fromJson(tPostJson);

        // Assert
        expect(result.id, 1);
        expect(result.userId, 10);
        expect(result.title, 'Test Post Title');
        expect(result.body, 'Test post body content');
      });

      test('should handle userId field with snake_case', () {
        // Arrange
        final jsonWithSnakeCase = {
          'id': 1,
          'userId': 10,
          'title': 'Test Post Title',
          'body': 'Test post body content',
        };

        // Act
        final result = PostModel.fromJson(jsonWithSnakeCase);

        // Assert
        expect(result.userId, 10);
      });

      test('should parse JSON with zero values', () {
        // Arrange
        final jsonWithZeros = {'id': 0, 'userId': 0, 'title': '', 'body': ''};

        // Act
        final result = PostModel.fromJson(jsonWithZeros);

        // Assert
        expect(result.id, 0);
        expect(result.userId, 0);
        expect(result.title, '');
        expect(result.body, '');
      });

      test('should parse JSON with large values', () {
        // Arrange
        final jsonWithLargeValues = {
          'id': 999999,
          'userId': 888888,
          'title': 'A' * 1000,
          'body': 'B' * 5000,
        };

        // Act
        final result = PostModel.fromJson(jsonWithLargeValues);

        // Assert
        expect(result.id, 999999);
        expect(result.userId, 888888);
        expect(result.title.length, 1000);
        expect(result.body.length, 5000);
      });

      test('should handle special characters in strings', () {
        // Arrange
        final jsonWithSpecialChars = {
          'id': 1,
          'userId': 10,
          'title': 'Title with émojis 🎉 and symbols @#\$%',
          'body': 'Body with\nnewlines\tand\ttabs',
        };

        // Act
        final result = PostModel.fromJson(jsonWithSpecialChars);

        // Assert
        expect(result.title, 'Title with émojis 🎉 and symbols @#\$%');
        expect(result.body, 'Body with\nnewlines\tand\ttabs');
      });
    });

    group('toJson', () {
      test('should return a valid JSON map from PostModel', () {
        // Act
        final result = tPostModel.toJson();

        // Assert
        expect(result, tPostJson);
        expect(result['id'], 1);
        expect(result['userId'], 10);
        expect(result['title'], 'Test Post Title');
        expect(result['body'], 'Test post body content');
      });

      test('should serialize with correct field names', () {
        // Act
        final result = tPostModel.toJson();

        // Assert
        expect(result.containsKey('userId'), true);
        expect(result.containsKey('user_id'), false);
      });

      test('should preserve all field values', () {
        // Arrange
        const modelWithEdgeCases = PostModel(
          id: 0,
          userId: 0,
          title: '',
          body: '',
        );

        // Act
        final result = modelWithEdgeCases.toJson();

        // Assert
        expect(result['id'], 0);
        expect(result['userId'], 0);
        expect(result['title'], '');
        expect(result['body'], '');
      });
    });

    group('toEntity', () {
      test('should return PostEntity with isLiked false by default', () {
        // Act
        final result = tPostModel.toEntity();

        // Assert
        expect(result, isA<PostEntity>());
        expect(result.id, tPostModel.id);
        expect(result.userId, tPostModel.userId);
        expect(result.title, tPostModel.title);
        expect(result.body, tPostModel.body);
        expect(result.isLiked, false);
      });

      test('should return PostEntity with isLiked true when specified', () {
        // Act
        final result = tPostModel.toEntity(isLiked: true);

        // Assert
        expect(result, isA<PostEntity>());
        expect(result.id, tPostModel.id);
        expect(result.userId, tPostModel.userId);
        expect(result.title, tPostModel.title);
        expect(result.body, tPostModel.body);
        expect(result.isLiked, true);
      });

      test('should maintain all properties during conversion', () {
        // Arrange
        const modelWithDifferentValues = PostModel(
          id: 42,
          userId: 99,
          title: 'Different Title',
          body: 'Different Body',
        );

        // Act
        final result = modelWithDifferentValues.toEntity(isLiked: true);

        // Assert
        expect(result.id, 42);
        expect(result.userId, 99);
        expect(result.title, 'Different Title');
        expect(result.body, 'Different Body');
        expect(result.isLiked, true);
      });
    });

    group('Serialization round-trip', () {
      test('should maintain data integrity through fromJson -> toJson', () {
        // Arrange
        final originalJson = {
          'id': 123,
          'userId': 456,
          'title': 'Round Trip Test',
          'body': 'Testing serialization round trip',
        };

        // Act
        final model = PostModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson, originalJson);
      });

      test('should maintain data integrity through toJson -> fromJson', () {
        // Arrange
        const originalModel = PostModel(
          id: 789,
          userId: 321,
          title: 'Another Round Trip',
          body: 'Testing deserialization round trip',
        );

        // Act
        final json = originalModel.toJson();
        final resultModel = PostModel.fromJson(json);

        // Assert
        expect(resultModel.id, originalModel.id);
        expect(resultModel.userId, originalModel.userId);
        expect(resultModel.title, originalModel.title);
        expect(resultModel.body, originalModel.body);
      });
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        const model1 = PostModel(
          id: 1,
          userId: 10,
          title: 'Title',
          body: 'Body',
        );
        const model2 = PostModel(
          id: 1,
          userId: 10,
          title: 'Title',
          body: 'Body',
        );

        // Assert
        expect(model1, model2);
      });

      test('should not be equal when properties differ', () {
        // Arrange
        const model1 = PostModel(
          id: 1,
          userId: 10,
          title: 'Title',
          body: 'Body',
        );
        const model2 = PostModel(
          id: 2,
          userId: 10,
          title: 'Title',
          body: 'Body',
        );

        // Assert
        expect(model1, isNot(model2));
      });
    });
  });
}
