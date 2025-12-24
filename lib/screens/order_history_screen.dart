import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../widgets/profile/order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Пример данных
    final orders = [
      OrderModel(
        orderNumber: '786529',
        totalPrice: 1832,
        itemCount: 3,
        status: OrderStatus.pending,
        date: '10 декабря 2025 в 15:37',
        address: 'г. Новосибирск, ул. Шахтеров, 59',
        dishImages: [
          'assets/images/food.png',
          'assets/images/food.png',
          'assets/images/food.png',
        ],
        recipient: 'Алексей Антонов',
        phone: '+7 (987) 389-20-19',
        paymentMethod: 'Наличным курьеру',
        deliveryPrice: 235,
        items: [
          OrderItem(
            name: 'Курица (грудка) с картофелем по-домашнему',
            price: 529,
            quantity: 1,
            weight: '500г',
            imageUrl: 'assets/images/food.png',
          ),
          OrderItem(
            name: 'Курица (грудка) с картофелем по-домашнему',
            price: 529,
            quantity: 1,
            weight: '500г',
            imageUrl: 'assets/images/food.png',
          ),
          OrderItem(
            name: 'Курица (грудка) с картофелем по-домашнему',
            price: 529,
            quantity: 1,
            weight: '500г',
            imageUrl: 'assets/images/food.png',
          ),
        ],
      ),
      OrderModel(
        orderNumber: '786529',
        totalPrice: 2135,
        itemCount: 3,
        status: OrderStatus.cancelled,
        date: '10 декабря 2025 в 15:37',
        address: 'г. Новосибирск, ул. Шахтеров, 59',
        dishImages: [
          'assets/images/food.png',
          'assets/images/food.png',
          'assets/images/food.png',
        ],
        recipient: 'Алексей Антонов',
        phone: '+7 (987) 389-20-19',
        paymentMethod: 'Наличным курьеру',
        deliveryPrice: 235,
        items: [],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('История заказов'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => OrderCard(order: orders[index]),
      ),
    );
  }
}
