import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/cart_model.dart';
import '../models/product_api_model.dart';

class ApiService {
  static const String baseUrl = 'https://eatcost.ru/wp-json/wp/v2';
  static const String backendUrl = 'http://91.218.229.214:8000/api/v1';

  String? _token;
  bool _isRefreshing = false;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> _getHeaders({bool withAuth = false}) {
    final headers = {'Content-Type': 'application/json'};

    if (withAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // ПОПЫТКА ОБНОВИТЬ ТОКЕН И ПОВТОРИТЬ ЗАПРОС
  Future<http.Response> _tryRefreshTokenAndRetry(
    Future<http.Response> Function() request,
    String url,
  ) async {
    final response = await request();

    if (response.statusCode == 401 && !_isRefreshing && _token != null) {
      _isRefreshing = true;

      try {
        // Пытаемся обновить токен
        final refreshResponse = await http.post(
          Uri.parse('$backendUrl/auth/refresh'),
          headers: _getHeaders(),
          body: jsonEncode({'jwt': _token}),
        );

        if (refreshResponse.statusCode == 200) {
          final data = jsonDecode(refreshResponse.body);
          final newToken = data['jwt'];

          if (newToken != null) {
            _token = newToken;
            // Сохраняем новый токен в SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', _token!);

            // Повторяем оригинальный запрос с новым токеном
            final retryResponse = await http.get(
              Uri.parse(url),
              headers: _getHeaders(withAuth: true),
            );

            return retryResponse;
          }
        }
      } catch (e) {
        // Игнорируем ошибки обновления токена
      } finally {
        _isRefreshing = false;
      }
    }

    return response;
  }

  // АВТОРИЗАЦИЯ
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['jwt'];
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Неверный email или пароль');
      } else {
        throw Exception('Ошибка авторизации: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // ПОЛУЧЕНИЕ ПРОФИЛЯ ПОЛЬЗОВАТЕЛЯ
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/users/profile'),
        headers: _getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Токен недействителен');
      } else {
        throw Exception('Ошибка загрузки профиля: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Существующие методы для постов...
  Future<List<Post>> fetchPosts({int perPage = 10, int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?per_page=$perPage&page=$page&_embed'),
      );
      if (response.statusCode == 200) {
        List body = jsonDecode(response.body);
        List<Post> posts = body
            .map((dynamic item) => Post.fromJson(item))
            .toList();
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
      final response = await http.get(Uri.parse('$baseUrl/posts/$id?_embed'));
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
      final response = await http.get(Uri.parse('$baseUrl/media/$mediaId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['source_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Membership> getMembership() async {
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/users/membership'),
        headers: _getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Membership.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Токен недействителен');
      } else {
        throw Exception('Ошибка загрузки подписки: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // ПОЛУЧЕНИЕ QR-КОДА ПОДПИСКИ
  Future<MembershipQR> getMembershipQR() async {
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/users/membership_qr'),
        headers: _getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MembershipQR.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Токен недействителен');
      } else {
        throw Exception('Ошибка загрузки QR-кода: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // ПОЛУЧЕНИЕ КОРЗИНЫ
  Future<Cart> getCart() async {
    try {
      final url = '$backendUrl/cart';
      final response = await _tryRefreshTokenAndRetry(
        () => http.get(Uri.parse(url), headers: _getHeaders(withAuth: true)),
        url,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Cart.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Токен недействителен');
      } else {
        throw Exception('Ошибка загрузки корзины: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // ДОБАВЛЕНИЕ ТОВАРА В КОРЗИНУ
  Future<void> addItemToCart({
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/cart/add-item'),
        headers: _getHeaders(withAuth: true),
        body: jsonEncode({'product_id': productId, 'quantity': quantity}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Токен недействителен');
      } else {
        throw Exception('Ошибка добавления товара: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // УДАЛЕНИЕ ТОВАРА ИЗ КОРЗИНЫ
  Future<Cart> removeItemFromCart({required String productKey}) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/cart/remove-item'),
        headers: _getHeaders(withAuth: true),
        body: jsonEncode({'product_key': productKey}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return Cart.fromJson(jsonData['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Токен недействителен');
      } else {
        throw Exception('Ошибка удаления товара: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // ИЗМЕНЕНИЕ КОЛИЧЕСТВА ТОВАРА В КОРЗИНЕ
  Future<void> editCartItem({
    required String key,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/cart/edit-item'),
        headers: _getHeaders(withAuth: true),
        body: jsonEncode({'key': key, 'quantity': quantity}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Токен недействителен');
      } else {
        throw Exception('Ошибка изменения количества: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // ПОЛУЧЕНИЕ ПРОДУКТОВ
  Future<List<ProductCategory>> getProducts({int? categoryId}) async {
    try {
      final queryParams = categoryId != null ? '?category_id=$categoryId' : '';
      final url = '$backendUrl/products$queryParams';
      final response = await http.get(Uri.parse(url), headers: _getHeaders());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => ProductCategory.fromJson(item)).toList();
      } else {
        throw Exception('Ошибка загрузки продуктов: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // ОБНОВЛЕНИЕ JWT ТОКЕНА
  Future<Map<String, dynamic>> refreshToken(String jwt) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/auth/refresh'),
        headers: _getHeaders(),
        body: jsonEncode({'jwt': jwt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Ошибка обновления токена: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  Future<Map<String, dynamic>> searchProducts({required String query}) async {
  final uri = Uri.parse('$backendUrl/products/search').replace(
    queryParameters: {'query': query},
  );
  
  final response = await http.get(
    uri,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    
    return {
      'query': data['query'],
      'count': data['count'],
      'results': (data['results'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    };
  } else {
    throw Exception('Ошибка поиска товаров: ${response.statusCode}');
  }
}

}
