import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subscription_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../widgets/subscription/subscription_card.dart';
import '../widgets/subscription/subscription_benefits.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Membership? _membership;
  MembershipQR? _membershipQR;
  bool _isLoading = true;
  bool _isLoadingQR = false;

  // Fallback subscription model for UI compatibility
  SubscriptionModel get _subscription => SubscriptionModel(
    status: _membership?.status ?? 'inactive',
    price: 400,
    expiryDate: _membership?.endDate,
    renewalType: 'automatic',
    benefits: [
      'Стоимость: 1500₽ в месяц',
      'Списание: Автоматически раз в месяц',
      'Главная выгода: Покупайте все товары по себестоимости',
    ],
  );

  @override
  void initState() {
    super.initState();
    _loadMembershipData();
  }

  Future<void> _loadMembershipData() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      _membership = await authService.apiService.getMembership();
    } catch (e) {
      debugPrint('Error loading membership: $e');
      // Show error snackbar if needed
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMembershipQR() async {
    setState(() => _isLoadingQR = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      _membershipQR = await authService.apiService.getMembershipQR();
    } catch (e) {
      debugPrint('Error loading QR code: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingQR = false);
      }
    }
  }

  Uint8List _decodeBase64Image(String base64String) {
    // Handle data URL format: "data:image/png;base64,<base64_data>"
    if (base64String.contains(',')) {
      base64String = base64String.split(',')[1];
    }
    return base64Decode(base64String);
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Отменить подписку?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Вы уверены, что хотите отменить подписку?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'После отмены вы потеряете доступ к:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ..._subscription.benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        benefit
                            .replaceAll('Стоимость: ', '')
                            .replaceAll('Списание: ', '')
                            .replaceAll('Главная выгода: ', ''),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Оставить подписку',
              style: TextStyle(
                color: Color(0xFF3D5A3E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelSubscription();
            },
            child: const Text(
              'Отменить',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelSubscription() {
    // TODO: Отправить запрос на отмену подписки
    // For now, just show success message and reload data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Подписка успешно отменена'),
        backgroundColor: Colors.red,
      ),
    );

    // Reload membership data
    _loadMembershipData();
  }

  void _showQRCode() async {
    // Load QR code data
    await _loadMembershipQR();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'QR-код подписки',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isLoadingQR
                    ? const Center(child: CircularProgressIndicator())
                    : _membershipQR != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _decodeBase64Image(_membershipQR!.qrCode),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.qr_code,
                                  size: 150,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.qr_code,
                            size: 150,
                            color: Colors.grey,
                          ),
              ),
              const SizedBox(height: 16),
              Text(
                _membershipQR != null && !_membershipQR!.isExpired
                    ? 'Покажите этот код для получения скидки\nОбновляется автоматически'
                    : 'Код устарел. Попробуйте обновить.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              if (_membershipQR != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Истекает через: ${_membershipQR!.remainingSeconds} сек',
                  style: TextStyle(
                    fontSize: 12,
                    color: _membershipQR!.remainingSeconds < 10
                        ? Colors.red
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _loadMembershipQR();
                setState(() {}); // Refresh dialog
              },
              child: const Text('Обновить'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
          ],
        ),
      ),
    );

    // Auto-refresh every 60 seconds if dialog is open
    if (_membershipQR != null) {
      Future.delayed(const Duration(seconds: 60), () {
        if (mounted && Navigator.of(context).canPop()) {
          _loadMembershipQR();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Моя подписка'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Моя подписка'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка подписки
            SubscriptionCard(
              subscription: _subscription,
              onShowQR: _showQRCode,
            ),
            const SizedBox(height: 24),

            // Преимущества подписки
            SubscriptionBenefits(benefits: _subscription.benefits),
            const SizedBox(height: 24),

            // Кнопки действий
            if (_subscription.isActive) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _showCancelDialog,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Отменить подписку',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Активировать подписку
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Подписка активирована')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C4C3B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Активировать подписку',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Контактная информация
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Задать вопрос',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'support@eatcost.ru',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
