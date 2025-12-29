import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  UserProfile? _userProfile; // Добавляем профиль пользователя
  
  final ApiService apiService = ApiService();

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  UserProfile? get userProfile => _userProfile;
  
  // Геттеры для обратной совместимости
  String? get userName => _userProfile?.fullName;
  String? get userEmail => _userProfile?.email;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _token = prefs.getString('token');

    apiService.setToken(_token);
    // Устанавливаем callback для обработки ошибок авторизации
    apiService.setOnAuthError(() {
      logout();
    });

    // Если авторизован, загружаем профиль
    if (_isLoggedIn && _token != null) {
      await loadUserProfile();
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await apiService.login(
        email: email,
        password: password,
      );

      _token = response['jwt'];
      apiService.setToken(_token);

      // Загружаем профиль пользователя
      await loadUserProfile();

      _isLoggedIn = true;

      // Сохраняем в локальное хранилище
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', _token!);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String username) async {
    try {
      final response = await apiService.register(
        email: email,
        password: password,
        username: username,
      );

      _token = response['jwt'];
      apiService.setToken(_token);

      // Загружаем профиль пользователя
      await loadUserProfile();

      _isLoggedIn = true;

      // Сохраняем в локальное хранилище
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', _token!);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  /// Загрузка профиля пользователя
  Future<void> loadUserProfile() async {
    try {
      _userProfile = await apiService.getUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Load profile error: $e');
    }
  }

  /// Обновление профиля (если будет эндпоинт)
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? address,
  }) async {
    // TODO: Реализовать когда появится эндпоинт обновления
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _token = null;
    _userProfile = null;

    apiService.setToken(null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // ОБНОВЛЕНИЕ JWT ТОКЕНА
  Future<bool> refreshToken() async {
    if (_token == null) return false;

    try {
      final response = await apiService.refreshToken(_token!);
      final newToken = response['jwt'];

      if (newToken != null) {
        _token = newToken;
        apiService.setToken(_token);

        // Сохраняем новый токен
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);

        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
      // Если обновление не удалось, выходим из системы
      await logout();
    }

    return false;
  }
}
