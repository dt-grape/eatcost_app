class SubscriptionModel {
  final String status; // 'active', 'inactive', 'expired'
  final int price;
  final DateTime? expiryDate;
  final String renewalType; // 'automatic', 'manual'
  final List<String> benefits;

  SubscriptionModel({
    required this.status,
    required this.price,
    this.expiryDate,
    required this.renewalType,
    required this.benefits,
  });

  bool get isActive => status == 'active';
  
  String get expiryDateFormatted {
    if (expiryDate == null) return '';
    final day = expiryDate!.day.toString().padLeft(2, '0');
    final month = expiryDate!.month.toString().padLeft(2, '0');
    final year = expiryDate!.year;
    return '$day.$month.$year';
  }
}
