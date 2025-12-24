import 'package:flutter/material.dart';

class DeliveryAddressInput extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController apartmentController;
  final TextEditingController entranceController;
  final TextEditingController floorController;
  final TextEditingController commentController;

  const DeliveryAddressInput({
    super.key,
    required this.addressController,
    required this.apartmentController,
    required this.entranceController,
    required this.floorController,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите адрес доставки',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        
        // Основной адрес
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            hintText: 'Город, улица, дом',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFFF7F7F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 12),

        // Выбрать на карте
        InkWell(
          onTap: () {
            // TODO: Открыть карту
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Открыть карту')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: const Color(0xFF3D5A3E),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Выбрать адрес на карте',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3D5A3E),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Кв/офис и Подъезд
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: apartmentController,
                decoration: InputDecoration(
                  hintText: 'Кв/офис',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: entranceController,
                decoration: InputDecoration(
                  hintText: 'Подъезд',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: floorController,
                decoration: InputDecoration(
                  hintText: 'Этаж',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Комментарий к адресу
        TextField(
          controller: commentController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Комментарий к адресу',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFFF7F7F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
