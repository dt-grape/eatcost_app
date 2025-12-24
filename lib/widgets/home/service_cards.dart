import 'pickup_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'delivery_bottom_sheet.dart';

class ServiceCards extends StatelessWidget {
  const ServiceCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildCard(
              context: context,
              title: 'Доставка',
              color: const Color(0xFFE07B39),
              imagePath: 'assets/images/moto.png',
              onTap: () => _showDeliveryBottomSheet(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildCard(
              context: context,
              title: 'Самовывоз',
              color: const Color(0xFF4CAF50),
              imagePath: 'assets/images/shop.png',
              onTap: () => _showPickupBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required Color color,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  imagePath,
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      width: 120,
                      height: 100,
                      child: Icon(
                        title == 'Доставка'
                            ? Icons.delivery_dining
                            : Icons.storefront,
                        size: 70,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeliveryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DeliveryBottomSheet(),
    );
  }

  void _showPickupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PickupBottomSheet(),
    );
  }
}
