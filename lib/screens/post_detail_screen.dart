import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  Future<Map<String, dynamic>> fetchPostDetails() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load post details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Post Details'),
        backgroundColor: Colors.yellow[100],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPostDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final post = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(post['body'], style: const TextStyle(fontSize: 16)),
          );
        },
      ),
    );
  }
}
