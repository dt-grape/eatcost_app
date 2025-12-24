import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../widgets/checkout/payment_method_selector.dart';
import '../widgets/checkout/delivery_method_selector.dart';
import '../widgets/checkout/delivery_address_input.dart';
import '../widgets/checkout/checkout_summary.dart';

enum PaymentMethod { card, cash }

enum DeliveryMethod { courier, pickup }

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final int productsTotal;
  final int deliveryFee;
  final int discount;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.productsTotal,
    required this.deliveryFee,
    required this.discount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.card;
  DeliveryMethod _selectedDelivery = DeliveryMethod.courier;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();

  int get _totalItems =>
      widget.cartItems.fold(0, (sum, item) => sum + item.quantity);
  int get _finalTotal =>
      widget.productsTotal + widget.deliveryFee - widget.discount;

  @override
  void dispose() {
    _addressController.dispose();
    _apartmentController.dispose();
    _entranceController.dispose();
    _floorController.dispose();
    _commentController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    // Валидация
    if (_selectedDelivery == DeliveryMethod.courier &&
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Укажите адрес доставки')));
      return;
    }

    // TODO: Отправить заказ на сервер
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Заказ оформлен'),
        content: const Text('Ваш заказ успешно оформлен!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Оформление заказа'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Способ оплаты
                _buildSectionTitle('Способ оплаты'),
                const SizedBox(height: 12),
                PaymentMethodSelector(
                  selectedMethod: _selectedPayment,
                  onChanged: (method) {
                    setState(() {
                      _selectedPayment = method;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Способ доставки
                _buildSectionTitle('Способы доставки'),
                const SizedBox(height: 12),
                DeliveryMethodSelector(
                  selectedMethod: _selectedDelivery,
                  onChanged: (method) {
                    setState(() {
                      _selectedDelivery = method;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Адрес доставки
                if (_selectedDelivery == DeliveryMethod.courier) ...[
                  DeliveryAddressInput(
                    addressController: _addressController,
                    apartmentController: _apartmentController,
                    entranceController: _entranceController,
                    floorController: _floorController,
                    commentController: _commentController,
                  ),
                  const SizedBox(height: 24),
                ],

                // Комментарий к заказу (если самовывоз)
                if (_selectedDelivery == DeliveryMethod.pickup) ...[
                  _buildSectionTitle('Комментарии к заказу'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Комментарий к адресу',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF7F7F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Промокод
                _buildPromoCodeSection(),
              ],
            ),
          ),

          // Итоговая сводка
          CheckoutSummary(
            totalItems: _totalItems,
            productsTotal: widget.productsTotal,
            deliveryFee: widget.deliveryFee,
            discount: widget.discount,
            finalTotal: _finalTotal,
            minimumOrderText: 'Минимальный заказ от 1529 ₽',
            onCheckout: _placeOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Expanded(
            child: Text(
              'Есть промокод?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
