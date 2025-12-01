import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/post.dart';

class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Fetch all posts
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonPosts = json.decode(response.body);
      return jsonPosts.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Create a new post
  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur de création');
    }
  }

  // Update an existing post
  Future<void> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur de mise à jour');
    }
  }

  // Delete a post
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erreur de suppression');
    }
  }
}