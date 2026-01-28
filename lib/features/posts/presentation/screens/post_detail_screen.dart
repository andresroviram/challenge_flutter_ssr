import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/glass_container.dart';
import '../notifiers/post_detail_notifier.dart';
import '../state/post_detail_state.dart';
import '../widgets/comment_list_item.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(postDetailNotifierProvider(widget.postId).notifier)
          .loadPostDetail(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postDetailNotifierProvider(widget.postId));

    return GlassBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
          title: const Text('Detalle del Post'),
          centerTitle: true,
        ),
        body: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(PostDetailState state) {
    switch (state.status) {
      case PostDetailStatus.initial:
      case PostDetailStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case PostDetailStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Ocurrió un error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(postDetailNotifierProvider(widget.postId).notifier)
                      .loadPostDetail(widget.postId);
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );

      case PostDetailStatus.success:
        if (state.post == null) {
          return const Center(child: Text('No se pudo cargar el post'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostCard(state),
              const SizedBox(height: 16),
              _buildCommentsSection(state),
            ],
          ),
        );
    }
  }

  Widget _buildPostCard(PostDetailState state) {
    final post = state.post!;

    return GlassContainer(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      blur: 15,
      opacity: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isTogglingLike
                  ? null
                  : () {
                      ref
                          .read(
                            postDetailNotifierProvider(widget.postId).notifier,
                          )
                          .toggleLike();
                    },
              icon: state.isTogglingLike
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(post.isLiked ? Icons.favorite : Icons.favorite_border),
              label: Text(post.isLiked ? 'Me gusta' : 'Dar me gusta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: post.isLiked ? Colors.red : Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(PostDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Comentarios (${state.comments.length})',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),

        if (state.comments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text('No hay comentarios disponibles')),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.comments.length,
            itemBuilder: (context, index) {
              final comment = state.comments[index];
              return CommentListItem(comment: comment);
            },
          ),
      ],
    );
  }
}
