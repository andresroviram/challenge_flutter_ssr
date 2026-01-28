import 'package:challenge_flutter_ssr/features/posts/domain/entities/post_entity.dart';
import 'package:challenge_flutter_ssr/features/posts/presentation/widgets/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:challenge_flutter_ssr/components/glass_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('PostListItem Widget Tests', () {
    testWidgets('should display post title and body', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post Title',
        body: 'Test post body content',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.text('Test post body content'), findsOneWidget);
    });

    testWidgets('should display favorite_border icon when post is not liked', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test body',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      final iconFinder = find.byIcon(Icons.favorite_border);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, Colors.grey);
    });

    testWidgets('should display favorite icon when post is liked', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test body',
        isLiked: true,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      final iconFinder = find.byIcon(Icons.favorite);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, Colors.red);
    });

    testWidgets('should be wrapped in a Card widget', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test body',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      expect(find.byType(GlassContainer), findsOneWidget);
    });

    testWidgets('should navigate to post detail when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 42,
        userId: 1,
        title: 'Test Post',
        body: 'Test body',
        isLiked: false,
      );

      String? navigatedRoute;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                Scaffold(body: PostListItem(post: post)),
          ),
          GoRoute(
            path: '/post/:id',
            builder: (context, state) {
              navigatedRoute = state.matchedLocation;
              return const Scaffold(body: Center(child: Text('Post Detail')));
            },
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Tap on the post item
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Assert
      expect(navigatedRoute, '/post/42');
      expect(find.text('Post Detail'), findsOneWidget);
    });

    testWidgets('should truncate long title with ellipsis', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title:
            'This is a very long title that should be truncated '
            'because it exceeds the maximum number of lines allowed '
            'in the widget layout',
        body: 'Test body',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      final textFinder = find.text(post.title);
      expect(textFinder, findsOneWidget);

      final text = tester.widget<Text>(textFinder);
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should truncate long body with ellipsis', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body:
            'This is a very long body text that should be truncated '
            'because it exceeds the maximum number of lines allowed '
            'in the widget layout. It contains multiple sentences '
            'and should display an ellipsis at the end when truncated.',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      final bodyTextFinder = find.text(post.body);
      expect(bodyTextFinder, findsOneWidget);

      final bodyText = tester.widget<Text>(bodyTextFinder);
      expect(bodyText.maxLines, 3);
      expect(bodyText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should have proper spacing between elements', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: 'Test Post',
        body: 'Test body',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert - Check that SizedBox widgets exist for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should apply correct styling to title', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: 'Styled Title',
        body: 'Test body',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      final titleFinder = find.text('Styled Title');
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should handle empty title and body gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      const post = PostEntity(
        id: 1,
        userId: 1,
        title: '',
        body: '',
        isLiked: false,
      );

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostListItem(post: post)),
          ),
        ),
      );

      // Assert
      expect(find.byType(PostListItem), findsOneWidget);
      expect(find.text(''), findsNWidgets(2)); // title and body
    });
  });
}
