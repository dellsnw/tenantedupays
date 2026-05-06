import 'package:flutter/material.dart';

class Order {
  final String id;
  final String customerName;
  final String menuName;
  final double price;
  final String status;
  final DateTime orderTime;
  final String? note;
  final int quantity;
  final String? secondMenuName;
  final double? secondMenuPrice;
  final int secondQuantity;
  final Color avatarColor;
  final String avatarImagePath;
  final String? cancelReason;
  final DateTime? cancelTime;

  Order({
    required this.id,
    required this.customerName,
    required this.menuName,
    required this.price,
    required this.status,
    required this.orderTime,
    this.note,
    this.quantity = 1,
    this.secondMenuName,
    this.secondMenuPrice,
    this.secondQuantity = 1,
    required this.avatarColor,
    required this.avatarImagePath,
    this.cancelReason,
    this.cancelTime,
  });

  double get totalPrice => (price * quantity) +
      ((secondMenuPrice ?? 0) * (secondMenuName == null ? 0 : secondQuantity));

  String get summary {
    if (secondMenuName == null) {
      return '$quantity x $menuName';
    }
    return '$quantity x $menuName, $secondQuantity x $secondMenuName';
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'] ?? '',
      customerName: json['customer_name'] ?? 'Pelanggan',
      menuName: json['menu_name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      status: json['status'] ?? 'Menunggu',
      orderTime: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      note: json['note'],
      quantity: json['quantity'] ?? 1,
      secondMenuName: json['second_menu_name'],
      secondMenuPrice: double.tryParse(json['second_menu_price'].toString()),
      secondQuantity: json['second_quantity'] ?? 0,
      avatarColor: const Color(0xFF00BCC9), // Default
      avatarImagePath: json['customer_photo'] ?? 'assets/images/pembeli_default.jpg',
      cancelReason: json['cancel_reason'],
      cancelTime: DateTime.tryParse(json['cancel_time'] ?? ''),
    );
  }
}
