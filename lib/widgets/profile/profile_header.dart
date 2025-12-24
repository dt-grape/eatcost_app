import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String? userName;
  final String? userPhone;

  const ProfileHeader({
    super.key,
    this.userName,
    this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Аватар
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF3D5A3E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),

          // Имя и телефон
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? 'Гость',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (userPhone != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    userPhone!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Кнопка редактирования
          IconButton(
            onPressed: () {
              // Переход к редактированию профиля
            },
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
