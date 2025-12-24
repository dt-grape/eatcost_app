import 'package:flutter/material.dart';

class OrderItemsPreview extends StatelessWidget {
  final List<String> dishImages;

  const OrderItemsPreview({
    super.key,
    required this.dishImages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < dishImages.length && i < 3; i++)
          Padding(
            padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                dishImages[i],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.restaurant,
                      color: Colors.grey.shade400,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
