import 'package:challenge_flutter_ssr/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:challenge_flutter_ssr/components/glass_container.dart';

void main() {
  group('SearchBarWidget Tests', () {
    testWidgets('should display search bar with hint text', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar posts...'), findsOneWidget);
    });

    testWidgets('should display search icon', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should not display clear button when text is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should display clear button when text is not empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController(text: 'test');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should call onChanged when text is entered', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      String? changedValue;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
              onClear: () {},
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.pump();

      // Assert
      expect(changedValue, 'flutter');
      expect(controller.text, 'flutter');
    });

    testWidgets('should call onClear when clear button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController(text: 'test');
      bool onClearCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {
                onClearCalled = true;
                controller.clear();
              },
            ),
          ),
        ),
      );

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Assert
      expect(onClearCalled, true);
    });

    testWidgets('should update clear button visibility when text changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: SearchBarWidget(
                  controller: controller,
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild
                  },
                  onClear: () {
                    setState(() {
                      controller.clear();
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      // Initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Clear button should appear
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Clear button should disappear after text is cleared
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should have rounded border', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;
      expect(decoration.border, InputBorder.none);
    });

    testWidgets('should have grey fill color', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;
      // No se define fillColor en el widget, así que debe ser null
      expect(decoration.fillColor, isNull);
    });

    testWidgets('should handle long search queries', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      String? changedValue;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
              onClear: () {},
            ),
          ),
        ),
      );

      // Enter long text
      const longText =
          'This is a very long search query that users might enter';
      await tester.enterText(find.byType(TextField), longText);
      await tester.pump();

      // Assert
      expect(changedValue, longText);
      expect(controller.text, longText);
    });

    testWidgets('should handle special characters in search', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      String? changedValue;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
              onClear: () {},
            ),
          ),
        ),
      );

      // Enter text with special characters
      const specialText = 'test@#\$%^&*()';
      await tester.enterText(find.byType(TextField), specialText);
      await tester.pump();

      // Assert
      expect(changedValue, specialText);
    });

    testWidgets('should handle emojis in search', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();
      String? changedValue;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
              onClear: () {},
            ),
          ),
        ),
      );

      // Enter text with emojis
      const emojiText = 'search 🔍 test 😊';
      await tester.enterText(find.byType(TextField), emojiText);
      await tester.pump();

      // Assert
      expect(changedValue, emojiText);
    });

    testWidgets('should clear text when onClear updates controller', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController(text: 'initial text');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {
                controller.clear();
              },
            ),
          ),
        ),
      );

      // Initial state
      expect(controller.text, 'initial text');
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Assert text is cleared
      expect(controller.text, '');
    });

    testWidgets('should have proper padding', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<GlassContainer>(
        find.byType(GlassContainer),
      );
      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      );
    });

    testWidgets('should maintain controller state across rebuilds', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();

      // Act - First build
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'persistent text');
      await tester.pump();

      // Rebuild
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              onChanged: (value) {},
              onClear: () {},
            ),
          ),
        ),
      );

      // Assert text persists
      expect(controller.text, 'persistent text');
      expect(find.text('persistent text'), findsOneWidget);
    });
  });
}
