import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  static const String baseUrl = 'https://eatcost.ru/wp-json/wp/v2';

  Future<List<Post>> fetchPosts({int perPage = 10, int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?per_page=$perPage&page=$page&_embed'),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Post> posts = body.map((dynamic item) => Post.fromJson(item)).toList();
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Post> fetchPostById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$id?_embed'),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String?> fetchFeaturedImageUrl(int mediaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/media/$mediaId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['source_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
