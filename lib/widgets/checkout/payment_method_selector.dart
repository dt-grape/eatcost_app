import 'package:flutter/material.dart';
import '../../screens/checkout_screen.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentOption(
          context,
          method: PaymentMethod.card,
          title: 'Оплата картой онлайн',
          icons: [
            'assets/icons/mastercard.png',
            'assets/icons/visa.png',
            'assets/icons/mir.png',
          ],
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          context,
          method: PaymentMethod.cash,
          title: 'Наличными при получении',
          icon: Icons.payments_outlined,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required PaymentMethod method,
    required String title,
    IconData? icon,
    List<String>? icons,
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
            // Иконки или текст
            if (icons != null)
              Row(
                children: [
                  _buildPaymentIcon('M', Colors.red),
                  const SizedBox(width: 4),
                  _buildPaymentIcon('V', Colors.blue),
                  const SizedBox(width: 4),
                  _buildPaymentIcon('М', Colors.green),
                ],
              )
            else if (icon != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.black87),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Radio<PaymentMethod>(
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

  Widget _buildPaymentIcon(String text, Color color) {
    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
