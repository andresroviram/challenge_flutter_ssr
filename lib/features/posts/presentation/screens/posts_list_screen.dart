import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/native/notification_providers.dart';
import '../../../../components/glass_container.dart';
import '../../../../components/notification_settings_helper.dart';
import '../../domain/entities/entities.dart';
import '../notifiers/posts_notifier.dart';
import '../state/posts_state.dart';
import '../widgets/post_list_item.dart';
import '../widgets/search_bar_widget.dart';

class PostsListScreen extends ConsumerStatefulWidget {
  const PostsListScreen({super.key});

  @override
  ConsumerState<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends ConsumerState<PostsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(postsNotifierProvider.notifier).loadPosts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsNotifierProvider);

    return GlassBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SizedBox.expand(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchBarWidget(
                            controller: _searchController,
                            onChanged: (value) {
                              ref
                                  .read(postsNotifierProvider.notifier)
                                  .searchPosts(value);
                            },
                            onClear: () {
                              _searchController.clear();
                              ref
                                  .read(postsNotifierProvider.notifier)
                                  .searchPosts('');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        GlassContainer(
                          padding: const EdgeInsets.all(4),
                          margin: EdgeInsets.zero,
                          blur: 15,
                          opacity: 0.25,
                          child: IconButton(
                            icon: const Icon(Icons.notifications_active),
                            onPressed: () {
                              NotificationSettingsHelper.showPopOnScreenGuide(
                                context,
                                onOpenSettings: () {
                                  ref
                                      .read(notificationApiProvider)
                                      .openNotificationSettings();
                                },
                              );
                            },
                            tooltip: 'Configurar notificaciones emergentes',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollStartNotification) {
                          FocusScope.of(context).unfocus();
                        }
                        return false;
                      },
                      child: _buildBody(postsState),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(PostsState state) {
    return state.when(
      initial: _buildLoadingState,
      loading: _buildLoadingState,
      success: _buildPostsList,
      error: _buildErrorState,
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(postsNotifierProvider.notifier).refreshPosts();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(
    List<PostEntity> posts,
    List<PostEntity> filteredPosts,
    String searchQuery,
  ) {
    if (filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty
                  ? 'No hay posts disponibles'
                  : 'No se encontraron posts',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(postsNotifierProvider.notifier).refreshPosts();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return PostListItem(post: post);
        },
      ),
    );
  }
}
