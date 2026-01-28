// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:challenge_flutter_ssr/core/network/dio_client.dart';
import 'package:challenge_flutter_ssr/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:challenge_flutter_ssr/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:challenge_flutter_ssr/features/posts/presentation/providers/posts_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mocks
class MockDioClient extends Mock implements DioClient {}

class MockPostsRemoteDataSource extends Mock implements PostsRemoteDataSource {}

class MockPostsLocalDataSource extends Mock implements PostsLocalDataSource {}

void main() {
  group('Widget Tests with SharedPreferences', () {
    testWidgets('SharedPreferences should be initialized correctly', (
      WidgetTester tester,
    ) async {
      // Configurar SharedPreferences mock vacío
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      // Verificar que SharedPreferences está inicializado
      expect(sharedPreferences, isNotNull);

      // Verificar que podemos guardar y leer datos
      await sharedPreferences.setString('test_key', 'test_value');
      final value = sharedPreferences.getString('test_key');
      expect(value, 'test_value');
    });

    testWidgets('SharedPreferences should persist liked posts', (
      WidgetTester tester,
    ) async {
      // Configurar SharedPreferences mock con datos de likes
      SharedPreferences.setMockInitialValues({'liked_posts': '[1,2,3]'});
      final sharedPreferences = await SharedPreferences.getInstance();

      // Verificar que los likes persisten
      final likedPostsJson = sharedPreferences.getString('liked_posts');
      expect(likedPostsJson, '[1,2,3]');

      // Agregar un nuevo like
      await sharedPreferences.setString('liked_posts', '[1,2,3,4]');
      final updatedLikes = sharedPreferences.getString('liked_posts');
      expect(updatedLikes, '[1,2,3,4]');
    });

    testWidgets('LocalDataSource should use SharedPreferences correctly', (
      WidgetTester tester,
    ) async {
      // Configurar SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      // Crear LocalDataSource con SharedPreferences real
      final localDataSource = PostsLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );

      // Verificar que no hay likes inicialmente
      final initialLikes = await localDataSource.getLikedPostIds();
      expect(initialLikes, isEmpty);

      // Toggle like en un post
      final isLiked = await localDataSource.toggleLike(1);
      expect(isLiked, true);

      // Verificar que el like se guardó
      final likes = await localDataSource.getLikedPostIds();
      expect(likes, {1});

      // Verificar que SharedPreferences contiene el dato
      final savedData = sharedPreferences.getString('liked_posts');
      expect(savedData, '[1]');
    });

    testWidgets('App widget structure can be created with mocked providers', (
      WidgetTester tester,
    ) async {
      // Configurar SharedPreferences
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      // Crear mocks para evitar llamadas de red
      final mockRemoteDataSource = MockPostsRemoteDataSource();
      final mockLocalDataSource = MockPostsLocalDataSource();

      when(() => mockRemoteDataSource.getPosts()).thenAnswer((_) async => []);
      when(
        () => mockLocalDataSource.getLikedPostIds(),
      ).thenAnswer((_) async => <int>{});

      // Crear un widget simple que use ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            postsRemoteDataSourceProvider.overrideWithValue(
              mockRemoteDataSource,
            ),
            postsLocalDataSourceProvider.overrideWithValue(mockLocalDataSource),
          ],
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Test App')),
              body: const Center(
                child: Text('Testing SharedPreferences Integration'),
              ),
            ),
          ),
        ),
      );

      // Verificar que el widget se renderiza
      expect(find.text('Test App'), findsOneWidget);
      expect(
        find.text('Testing SharedPreferences Integration'),
        findsOneWidget,
      );
    });

    testWidgets('Multiple liked posts can be stored in SharedPreferences', (
      WidgetTester tester,
    ) async {
      // Configurar SharedPreferences
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      final localDataSource = PostsLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );

      // Agregar múltiples likes
      await localDataSource.toggleLike(1);
      await localDataSource.toggleLike(5);
      await localDataSource.toggleLike(10);

      // Verificar que todos se guardaron
      final likes = await localDataSource.getLikedPostIds();
      expect(likes, {1, 5, 10});
      expect(likes.length, 3);

      // Verificar en SharedPreferences
      final savedData = sharedPreferences.getString('liked_posts');
      expect(savedData, isNotNull);
      expect(savedData!.contains('1'), true);
      expect(savedData.contains('5'), true);
      expect(savedData.contains('10'), true);
    });

    testWidgets('Liked posts can be toggled on and off', (
      WidgetTester tester,
    ) async {
      // Configurar SharedPreferences
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      final localDataSource = PostsLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );

      // Like un post
      var isLiked = await localDataSource.toggleLike(1);
      expect(isLiked, true);

      // Verificar que está liked
      var liked = await localDataSource.isPostLiked(1);
      expect(liked, true);

      // Unlike el mismo post
      isLiked = await localDataSource.toggleLike(1);
      expect(isLiked, false);

      // Verificar que ya no está liked
      liked = await localDataSource.isPostLiked(1);
      expect(liked, false);
    });
  });
}
