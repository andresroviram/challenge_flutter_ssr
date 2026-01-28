import 'package:go_router/go_router.dart';
import '../../features/posts/presentation/screens/posts_list_screen.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../components/error_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const PostsListScreen(),
    ),
    GoRoute(
      path: '/post/:id',
      name: 'post-detail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return PostDetailScreen(postId: id);
      },
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
