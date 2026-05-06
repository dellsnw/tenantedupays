import 'package:flutter/material.dart';

class MenuItemData {
  final int? id;
  final String name;
  final String category;
  final String description;
  final double price;
  final int stock;
  final IconData? icon;
  final Color? color;
  final String imagePath;
  bool isAvailable;

  MenuItemData({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    this.icon,
    this.color,
    required this.imagePath,
    required this.isAvailable,
  });

  factory MenuItemData.fromJson(Map<String, dynamic> json) {
    return MenuItemData(
      id: json['id'],
      name: json['name'] ?? '',
      category: json['category'] ?? 'Makanan',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      imagePath: json['image_path'] ?? 'assets/images/default.jpg',
      isAvailable: (json['is_available'] == 1 || json['is_available'] == true),
      // Icon and color are usually local UI helpers, but can be mapped
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'stock': stock,
      'is_available': isAvailable ? 1 : 0,
      'image_path': imagePath,
    };
  }
}
