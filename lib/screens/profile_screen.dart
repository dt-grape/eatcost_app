import 'package:eatcost_app/screens/edit_profile_screen.dart';
import 'package:eatcost_app/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_menu_item.dart';
import '../widgets/profile/subscription_banner.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final authService = context.read<AuthService>();
    await authService.loadUserProfile();
    
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final profile = authService.userProfile;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Заголовок профиля
                    ProfileHeader(
                      userName: profile?.fullName ?? 'Загрузка...',
                      userPhone: profile?.email ?? '',
                    ),
                    const SizedBox(height: 16),

                    // Профиль
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Профиль',
                      subtitle: profile != null
                          ? '${profile.firstName} ${profile.lastName}'
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),

                    // История заказов
                    ProfileMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'История заказов',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryScreen(),
                          ),
                        );
                      },
                    ),

                    // Баннер подписки (всегда используем SubscriptionBanner)
                    SubscriptionBanner(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubscriptionScreen(),
                          ),
                        );
                      },
                    ),

                    // Способы оплаты
                    ProfileMenuItem(
                      icon: Icons.credit_card_outlined,
                      title: 'Способы оплаты',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Способы оплаты')),
                        );
                      },
                    ),

                    // Мои адреса
                    ProfileMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Мои адреса',
                      subtitle: profile?.address ?? 'Не указан',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Мои адреса')),
                        );
                      },
                    ),

                    // Выйти из профиля
                    ProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Выйти из профиля',
                      iconColor: Colors.red,
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      onTap: () {
                        _showLogoutDialog(context, authService);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти из профиля?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pop(context);
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
