import 'package:challenge_flutter_ssr/features/posts/data/models/comment_model.dart';
import 'package:challenge_flutter_ssr/features/posts/domain/entities/comment_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommentModel', () {
    const tCommentModel = CommentModel(
      id: 1,
      postId: 10,
      name: 'John Doe',
      email: 'john@example.com',
      body: 'This is a test comment',
    );

    final tCommentJson = {
      'id': 1,
      'postId': 10,
      'name': 'John Doe',
      'email': 'john@example.com',
      'body': 'This is a test comment',
    };

    group('fromJson', () {
      test('should return a valid CommentModel from JSON', () {
        // Act
        final result = CommentModel.fromJson(tCommentJson);

        // Assert
        expect(result.id, 1);
        expect(result.postId, 10);
        expect(result.name, 'John Doe');
        expect(result.email, 'john@example.com');
        expect(result.body, 'This is a test comment');
      });

      test('should parse JSON with zero values', () {
        // Arrange
        final jsonWithZeros = {
          'id': 0,
          'postId': 0,
          'name': '',
          'email': '',
          'body': '',
        };

        // Act
        final result = CommentModel.fromJson(jsonWithZeros);

        // Assert
        expect(result.id, 0);
        expect(result.postId, 0);
        expect(result.name, '');
        expect(result.email, '');
        expect(result.body, '');
      });

      test('should parse JSON with large values', () {
        // Arrange
        final jsonWithLargeValues = {
          'id': 999999,
          'postId': 888888,
          'name': 'A' * 500,
          'email': 'user@${'example' * 50}.com',
          'body': 'B' * 5000,
        };

        // Act
        final result = CommentModel.fromJson(jsonWithLargeValues);

        // Assert
        expect(result.id, 999999);
        expect(result.postId, 888888);
        expect(result.name.length, 500);
        expect(result.body.length, 5000);
      });

      test('should handle special characters and unicode', () {
        // Arrange
        final jsonWithSpecialChars = {
          'id': 1,
          'postId': 10,
          'name': 'José María 🎉',
          'email': 'josé@españá.com',
          'body': 'Comment with\nnewlines\tand émojis 😊',
        };

        // Act
        final result = CommentModel.fromJson(jsonWithSpecialChars);

        // Assert
        expect(result.name, 'José María 🎉');
        expect(result.email, 'josé@españá.com');
        expect(result.body, 'Comment with\nnewlines\tand émojis 😊');
      });

      test('should handle various email formats', () {
        // Arrange
        final validEmails = [
          'simple@example.com',
          'user.name@example.com',
          'user+tag@example.co.uk',
          'user_name@sub.example.com',
        ];

        for (final email in validEmails) {
          final json = {
            'id': 1,
            'postId': 10,
            'name': 'Test User',
            'email': email,
            'body': 'Test body',
          };

          // Act
          final result = CommentModel.fromJson(json);

          // Assert
          expect(result.email, email);
        }
      });
    });

    group('toJson', () {
      test('should return a valid JSON map from CommentModel', () {
        // Act
        final result = tCommentModel.toJson();

        // Assert
        expect(result, tCommentJson);
        expect(result['id'], 1);
        expect(result['postId'], 10);
        expect(result['name'], 'John Doe');
        expect(result['email'], 'john@example.com');
        expect(result['body'], 'This is a test comment');
      });

      test('should serialize with correct field names', () {
        // Act
        final result = tCommentModel.toJson();

        // Assert
        expect(result.containsKey('postId'), true);
        expect(result.containsKey('post_id'), false);
      });

      test('should preserve all field values including edge cases', () {
        // Arrange
        const modelWithEdgeCases = CommentModel(
          id: 0,
          postId: 0,
          name: '',
          email: '',
          body: '',
        );

        // Act
        final result = modelWithEdgeCases.toJson();

        // Assert
        expect(result['id'], 0);
        expect(result['postId'], 0);
        expect(result['name'], '');
        expect(result['email'], '');
        expect(result['body'], '');
      });

      test('should preserve special characters', () {
        // Arrange
        const modelWithSpecialChars = CommentModel(
          id: 1,
          postId: 10,
          name: 'User & Co.',
          email: 'user+test@example.com',
          body: 'Text with "quotes" and \'apostrophes\'',
        );

        // Act
        final result = modelWithSpecialChars.toJson();

        // Assert
        expect(result['name'], 'User & Co.');
        expect(result['email'], 'user+test@example.com');
        expect(result['body'], 'Text with "quotes" and \'apostrophes\'');
      });
    });

    group('toEntity', () {
      test('should return CommentEntity with all properties', () {
        // Act
        final result = tCommentModel.toEntity();

        // Assert
        expect(result, isA<CommentEntity>());
        expect(result.id, tCommentModel.id);
        expect(result.postId, tCommentModel.postId);
        expect(result.name, tCommentModel.name);
        expect(result.email, tCommentModel.email);
        expect(result.body, tCommentModel.body);
      });

      test('should maintain all properties during conversion', () {
        // Arrange
        const modelWithDifferentValues = CommentModel(
          id: 42,
          postId: 99,
          name: 'Jane Smith',
          email: 'jane@test.com',
          body: 'Different comment body',
        );

        // Act
        final result = modelWithDifferentValues.toEntity();

        // Assert
        expect(result.id, 42);
        expect(result.postId, 99);
        expect(result.name, 'Jane Smith');
        expect(result.email, 'jane@test.com');
        expect(result.body, 'Different comment body');
      });

      test('should handle empty strings in entity conversion', () {
        // Arrange
        const modelWithEmptyStrings = CommentModel(
          id: 1,
          postId: 1,
          name: '',
          email: '',
          body: '',
        );

        // Act
        final result = modelWithEmptyStrings.toEntity();

        // Assert
        expect(result.name, '');
        expect(result.email, '');
        expect(result.body, '');
      });
    });

    group('Serialization round-trip', () {
      test('should maintain data integrity through fromJson -> toJson', () {
        // Arrange
        final originalJson = {
          'id': 123,
          'postId': 456,
          'name': 'Round Trip User',
          'email': 'roundtrip@test.com',
          'body': 'Testing serialization round trip',
        };

        // Act
        final model = CommentModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson, originalJson);
      });

      test('should maintain data integrity through toJson -> fromJson', () {
        // Arrange
        const originalModel = CommentModel(
          id: 789,
          postId: 321,
          name: 'Another User',
          email: 'another@test.com',
          body: 'Testing deserialization round trip',
        );

        // Act
        final json = originalModel.toJson();
        final resultModel = CommentModel.fromJson(json);

        // Assert
        expect(resultModel.id, originalModel.id);
        expect(resultModel.postId, originalModel.postId);
        expect(resultModel.name, originalModel.name);
        expect(resultModel.email, originalModel.email);
        expect(resultModel.body, originalModel.body);
      });

      test(
        'should maintain data through model -> entity -> model comparison',
        () {
          // Arrange
          const originalModel = CommentModel(
            id: 1,
            postId: 10,
            name: 'Test User',
            email: 'test@example.com',
            body: 'Test body',
          );

          // Act
          final entity = originalModel.toEntity();

          // Assert - Entity should have same values as model
          expect(entity.id, originalModel.id);
          expect(entity.postId, originalModel.postId);
          expect(entity.name, originalModel.name);
          expect(entity.email, originalModel.email);
          expect(entity.body, originalModel.body);
        },
      );
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        const model1 = CommentModel(
          id: 1,
          postId: 10,
          name: 'User',
          email: 'user@test.com',
          body: 'Body',
        );
        const model2 = CommentModel(
          id: 1,
          postId: 10,
          name: 'User',
          email: 'user@test.com',
          body: 'Body',
        );

        // Assert
        expect(model1, model2);
      });

      test('should not be equal when id differs', () {
        // Arrange
        const model1 = CommentModel(
          id: 1,
          postId: 10,
          name: 'User',
          email: 'user@test.com',
          body: 'Body',
        );
        const model2 = CommentModel(
          id: 2,
          postId: 10,
          name: 'User',
          email: 'user@test.com',
          body: 'Body',
        );

        // Assert
        expect(model1, isNot(model2));
      });

      test('should not be equal when postId differs', () {
        // Arrange
        const model1 = CommentModel(
          id: 1,
          postId: 10,
          name: 'User',
          email: 'user@test.com',
          body: 'Body',
        );
        const model2 = CommentModel(
          id: 1,
          postId: 20,
          name: 'User',
          email: 'user@test.com',
          body: 'Body',
        );

        // Assert
        expect(model1, isNot(model2));
      });

      test('should not be equal when any string property differs', () {
        // Arrange
        const baseModel = CommentModel(
          id: 1,
          postId: 10,
          name: 'User',
          email: 'user@test.com',
          body: 'Body',
        );

        const modelWithDifferentName = CommentModel(
          id: 1,
          postId: 10,
          name: 'Different User',
          email: 'user@test.com',
          body: 'Body',
        );

        const modelWithDifferentEmail = CommentModel(
          id: 1,
          postId: 10,
          name: 'User',
          email: 'different@test.com',
          body: 'Body',
        );

        const modelWithDifferentBody = CommentModel(
          id: 1,
          postId: 10,
          name: 'User',
          email: 'user@test.com',
          body: 'Different Body',
        );

        // Assert
        expect(baseModel, isNot(modelWithDifferentName));
        expect(baseModel, isNot(modelWithDifferentEmail));
        expect(baseModel, isNot(modelWithDifferentBody));
      });
    });

    group('Edge cases', () {
      test('should handle very long comment bodies', () {
        // Arrange
        final longBody = 'A' * 10000;
        final json = {
          'id': 1,
          'postId': 10,
          'name': 'User',
          'email': 'user@test.com',
          'body': longBody,
        };

        // Act
        final model = CommentModel.fromJson(json);

        // Assert
        expect(model.body.length, 10000);
        expect(model.body, longBody);
      });

      test('should handle multiline comment bodies', () {
        // Arrange
        const multilineBody = '''This is line 1
This is line 2
This is line 3''';
        final json = {
          'id': 1,
          'postId': 10,
          'name': 'User',
          'email': 'user@test.com',
          'body': multilineBody,
        };

        // Act
        final model = CommentModel.fromJson(json);

        // Assert
        expect(model.body, multilineBody);
        expect(model.body.contains('\n'), true);
      });
    });
  });
}
