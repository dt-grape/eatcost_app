class UserProfile {
  final String email;
  final String firstName;
  final String lastName;
  final String address;
  final Membership? membership;

  UserProfile({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.address,
    this.membership,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address: json['address'] ?? '',
      membership: json['membership'] != null
          ? Membership.fromJson(json['membership'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'membership': membership?.toJson(),
    };
  }
}

class Membership {
  final String planName;
  final String status;
  final DateTime? endDate;

  Membership({
    required this.planName,
    required this.status,
    this.endDate,
  });

  bool get isActive => status.toLowerCase() == 'active';

  String get statusText {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Активна';
      case 'expired':
        return 'Истекла';
      case 'cancelled':
        return 'Отменена';
      default:
        return status;
    }
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      planName: json['plan_name'] ?? '',
      status: json['status'] ?? '',
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_name': planName,
      'status': status,
      'end_date': endDate?.toIso8601String(),
    };
  }
}

// НОВАЯ МОДЕЛЬ ДЛЯ QR-КОДА
class MembershipQR {
  final String qrCode; // base64 строка
  final int timestamp;
  final int lifetime; // время жизни в секундах

  MembershipQR({
    required this.qrCode,
    required this.timestamp,
    required this.lifetime,
  });

  // Проверка, истёк ли срок действия QR-кода
  bool get isExpired {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return (now - timestamp) >= lifetime;
  }

  // Оставшееся время до истечения (в секундах)
  int get remainingSeconds {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final elapsed = now - timestamp;
    return lifetime - elapsed;
  }

  factory MembershipQR.fromJson(Map<String, dynamic> json) {
    return MembershipQR(
      qrCode: json['qr_code'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      lifetime: json['lifetime'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qr_code': qrCode,
      'timestamp': timestamp,
      'lifetime': lifetime,
    };
  }
}
