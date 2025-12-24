import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  String _getStatusText() {
    switch (status) {
      case OrderStatus.pending:
        return 'Ожидает оплату';
      case OrderStatus.cancelled:
        return 'Отменен';
      case OrderStatus.completed:
        return 'Завершен';
      case OrderStatus.inProgress:
        return 'В процессе';
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFF8BC34A);
      case OrderStatus.cancelled:
        return Colors.grey.shade600;
      case OrderStatus.completed:
        return const Color(0xFF4CAF50);
      case OrderStatus.inProgress:
        return const Color(0xFFFFA726);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(),
        ),
      ),
    );
  }
}
