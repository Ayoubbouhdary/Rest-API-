import 'package:flutter/material.dart';
import '../model/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post #${post.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Informations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('ID: ${post.id}'),
            Text('Longueur du titre: ${post.title.length} caractères'),
            Text('Longueur du contenu: ${post.body.length} caractères'),
          ],
        ),
      ),
    );
  }
}