import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String _error = '';

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final res = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      _posts = res.statusCode == 200
          ? (json.decode(res.body) as List)
              .map((e) => Post.fromJson(e))
              .toList()
          : [];
      _error = res.statusCode != 200 ? 'Failed to load posts' : '';
    } catch (e) {
      _posts = [];
      _error = 'Network error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
