import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      // Используем builder чтобы получить context с доступом к Provider
      builder: (context, child) {
        return MaterialApp(
          title: 'EatCost',
          theme: ThemeData(
            fontFamily: 'FFGoodPro',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2C4C3B),
            ),
          ),
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Используем mounted для безопасности
    if (!mounted) return;
    
    await Provider.of<AuthService>(context, listen: false).checkAuthStatus();
    
    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen пока проверяем авторизацию
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Color(0xFF2C4C3B),
              ),
              SizedBox(height: 16),
              Text(
                'EatCost',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C4C3B),
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: Color(0xFF2C4C3B),
              ),
            ],
          ),
        ),
      );
    }

    // После проверки показываем нужный экран
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return authService.isLoggedIn
            ? const MainScreen()
            : const LoginScreen();
      },
    );
  }
}
