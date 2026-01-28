import 'package:challenge_flutter_ssr/features/posts/domain/entities/comment_entity.dart';
import 'package:challenge_flutter_ssr/features/posts/presentation/widgets/comment_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:challenge_flutter_ssr/components/glass_container.dart';

void main() {
  group('CommentListItem Widget Tests', () {
    testWidgets('should display comment name, email and body', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'John Doe',
        email: 'john@example.com',
        body: 'This is a test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('This is a test comment'), findsOneWidget);
    });

    testWidgets('should display CircleAvatar with first letter of name', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Jane Smith',
        email: 'jane@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('should display lowercase name initial in uppercase', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'alice wonderland',
        email: 'alice@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('should be wrapped in a GlassContainer widget', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Test User',
        email: 'test@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('should truncate long name with ellipsis', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'This is a very long name that should be truncated with ellipsis',
        email: 'test@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      final nameFinder = find.text(comment.name);
      expect(nameFinder, findsOneWidget);

      final nameText = tester.widget<Text>(nameFinder);
      expect(nameText.maxLines, 1);
      expect(nameText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should truncate long email with ellipsis', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Test User',
        email: 'verylongemailaddress@verylongdomainname.example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      final emailFinder = find.text(comment.email);
      expect(emailFinder, findsOneWidget);

      final emailText = tester.widget<Text>(emailFinder);
      expect(emailText.maxLines, 1);
      expect(emailText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should display long comment body without truncation', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Test User',
        email: 'test@example.com',
        body:
            'This is a very long comment body that should not be truncated. '
            'It can span multiple lines and should be displayed in full. '
            'The comment body does not have a maxLines restriction.',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CommentListItem(comment: comment),
            ),
          ),
        ),
      );

      // Assert
      final bodyFinder = find.text(comment.body);
      expect(bodyFinder, findsOneWidget);

      final bodyText = tester.widget<Text>(bodyFinder);
      expect(bodyText.maxLines, null); // No line limit
    });

    testWidgets('should have proper spacing between elements', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Test User',
        email: 'test@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.byType(SizedBox), findsNWidgets(2));
    });

    testWidgets('should apply correct styling to name', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Styled Name',
        email: 'test@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      final nameFinder = find.text('Styled Name');
      final nameWidget = tester.widget<Text>(nameFinder);
      expect(nameWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should handle special characters in name', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'José María',
        email: 'jose@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.text('José María'), findsOneWidget);
      expect(find.text('J'), findsOneWidget); // First letter in avatar
    });

    testWidgets('should handle emojis in comment body', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Test User',
        email: 'test@example.com',
        body: 'Great post! 👍 😊 🎉',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.text('Great post! 👍 😊 🎉'), findsOneWidget);
    });

    testWidgets('should display comment with minimum required fields', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'A',
        email: 'a@b.c',
        body: 'Hi',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.text('A'), findsNWidgets(2)); // Name and avatar
      expect(find.text('a@b.c'), findsOneWidget);
      expect(find.text('Hi'), findsOneWidget);
    });

    testWidgets('should have proper layout with Row and Column', (
      WidgetTester tester,
    ) async {
      // Arrange
      const comment = CommentEntity(
        id: 1,
        postId: 1,
        name: 'Test User',
        email: 'test@example.com',
        body: 'Test comment',
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CommentListItem(comment: comment)),
        ),
      );

      // Assert
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(2)); // Outer and inner column
    });
  });
}
