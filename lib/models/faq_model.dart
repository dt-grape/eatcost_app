import 'package:flutter/material.dart';

enum FaqCategory {
  order,
  payment,
  delivery,
  subscription,
  discounts,
}

class FaqCategoryData {
  final FaqCategory category;
  final String title;
  final IconData icon;

  FaqCategoryData({
    required this.category,
    required this.title,
    required this.icon,
  });
}

class FaqItem {
  final String question;
  final String answer;
  final FaqCategory category;

  FaqItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
