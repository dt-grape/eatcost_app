import 'package:flutter/material.dart';
import '../../screens/checkout_screen.dart';

class DeliveryMethodSelector extends StatelessWidget {
  final DeliveryMethod selectedMethod;
  final ValueChanged<DeliveryMethod> onChanged;

  const DeliveryMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDeliveryOption(
          context,
          method: DeliveryMethod.pickup,
          title: 'Самовывоз из склада',
          subtitle: 'Заберите в г. Новосибирск, ул. Городская, 1А',
        ),
        const SizedBox(height: 12),
        _buildDeliveryOption(
          context,
          method: DeliveryMethod.courier,
          title: 'Доставка курьером',
          subtitle: 'Доставка курьером по указанному адресу',
        ),
      ],
    );
  }

  Widget _buildDeliveryOption(
    BuildContext context, {
    required DeliveryMethod method,
    required String title,
    required String subtitle,
  }) {
    final isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () => onChanged(method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF3D5A3E) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF3D5A3E).withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Radio<DeliveryMethod>(
              value: method,
              groupValue: selectedMethod,
              onChanged: (value) => onChanged(value!),
              activeColor: const Color(0xFF3D5A3E),
            ),
          ],
        ),
      ),
    );
  }
}
