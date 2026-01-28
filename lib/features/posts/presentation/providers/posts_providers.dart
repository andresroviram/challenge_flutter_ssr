import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/posts_remote_datasource.dart';
import '../../data/datasources/posts_local_datasource.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/usecases/posts_usecases.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final postsRemoteDataSourceProvider = Provider<PostsRemoteDataSource>((ref) {
  return PostsRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

final postsLocalDataSourceProvider = Provider<PostsLocalDataSource>((ref) {
  return PostsLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  return PostsRepositoryImpl(
    remoteDataSource: ref.watch(postsRemoteDataSourceProvider),
    localDataSource: ref.watch(postsLocalDataSourceProvider),
  );
});

final postsUseCaseProvider = Provider<PostsUseCase>((ref) {
  return PostsUseCase(ref.watch(postsRepositoryProvider));
});
