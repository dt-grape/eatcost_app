import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class MembershipCard extends StatefulWidget {
  const MembershipCard({super.key});

  @override
  State<MembershipCard> createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> {
  Membership? _membership;
  MembershipQR? _membershipQR;
  bool _isLoading = true;
  bool _isLoadingQR = false;

  @override
  void initState() {
    super.initState();
    _loadMembership();
  }

  Future<void> _loadMembership() async {
    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      _membership = await authService.apiService.getMembership();
    } catch (e) {
      debugPrint('Error loading membership: $e');
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
      debugPrint('Error loading QR: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingQR = false);
      }
    }
  }

  Uint8List _decodeBase64Image(String base64String) {
    if (base64String.contains(',')) {
      base64String = base64String.split(',')[1];
    }
    return base64Decode(base64String);
  }

  void _showQRDialog() async {
    await _loadMembershipQR();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                setDialogState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFB4BE7C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_membership == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFB4BE7C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.card_membership,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _membership!.isActive ? 'Подписка активна' : 'Подписка неактивна',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _membership!.isActive
                          ? 'Действует до ${_membership!.endDate}'
                          : 'Активируйте для получения скидок',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_membership!.isActive) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showQRDialog,
                icon: const Icon(Icons.qr_code, size: 20),
                label: const Text('Показать QR-код'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2C4C3B),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
