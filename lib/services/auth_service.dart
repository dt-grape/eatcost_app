import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName = "Тест тетсович";
  String? _userPhone = "+79999999999";

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userPhone => _userPhone;

  // Проверка статуса авторизации при старте
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName');
    _userPhone = prefs.getString('userPhone');
    notifyListeners();
  }

  // Моковая авторизация
  Future<bool> login(String phone, String code) async {
    // Симуляция задержки запроса
    await Future.delayed(const Duration(seconds: 1));

    // Моковая проверка (любой код подходит для демо)
    if (phone.isNotEmpty && code.length == 4) {
      _isLoggedIn = true;
      _userName = 'Иван Иванов'; // Моковое имя
      _userPhone = phone;

      // Сохраняем в локальное хранилище
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', _userName!);
      await prefs.setString('userPhone', _userPhone!);

      notifyListeners();
      return true;
    }

    return false;
  }

  // Выход
  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = null;
    _userPhone = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Регистрация (мок)
  Future<bool> register(String phone, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    _isLoggedIn = true;
    _userName = name;
    _userPhone = phone;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userPhone', phone);

    notifyListeners();
    return true;
  }
}
