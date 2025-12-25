import 'package:flutter/material.dart';
import '../../models/faq_model.dart';

class FaqItemWidget extends StatelessWidget {
  final FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;
  final int index;

  const FaqItemWidget({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Номер вопроса
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D5A3E).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D5A3E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Текст вопроса
                    Expanded(
                      child: Text(
                        item.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Иконка раскрытия
                    Icon(
                      isExpanded ? Icons.remove : Icons.add,
                      color: const Color(0xFF3D5A3E),
                      size: 24,
                    ),
                  ],
                ),
                // Ответ (показывается при раскрытии)
                if (isExpanded) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.answer,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
