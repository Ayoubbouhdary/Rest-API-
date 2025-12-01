import 'package:flutter/material.dart';
import '../model/post.dart';
import '../services/post_service.dart';
import 'post_detail.dart'; // Si tu crées cette page

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostService _postService = PostService();
  Future<List<Post>>? _posts;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    setState(() {
      _posts = _postService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          } else {
            final posts = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                _fetchPosts();
              },
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${post.id}'),
                    ),
                    title: Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      post.body.length > 50
                          ? '${post.body.substring(0, 50)}...'
                          : post.body,
                    ),
                    onTap: () {
                      // Navigation vers la page de détail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(post.id);
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(int postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le post'),
        content: const Text('Voulez-vous vraiment supprimer ce post ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _postService.deletePost(postId);
                _fetchPosts(); // Rafraîchir la liste
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post supprimé avec succès')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddPostDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Contenu'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final newPost = Post(
                id: 0,
                title: titleController.text,
                body: bodyController.text,
              );
              try {
                await _postService.createPost(newPost);
                Navigator.pop(context);
                _fetchPosts(); // Rafraîchir la liste
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post créé avec succès')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}