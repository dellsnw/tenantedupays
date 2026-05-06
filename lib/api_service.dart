import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/menu_item.dart';
import 'models/order.dart';

class ApiService {
  // Ganti baseUrl sesuai domain server backend Anda
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // --- AUTHENTICATION ---
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Email atau password salah');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal mendaftar');
      }
    } catch (e) {
      rethrow;
    }
  }

  // --- MENU MANAGEMENT ---

  static Future<List<MenuItemData>> getMenus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MenuItemData.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data menu');
      }
    } catch (e) {
      print('Error ApiService (getMenus): $e');
      return [];
    }
  }

  static Future<bool> addMenu(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateMenu(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteMenu(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProductStatus(int id, bool isAvailable) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/$id/status'),
        headers: _headers,
        body: jsonEncode({'status': isAvailable ? 'available' : 'unavailable'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // --- ORDER MANAGEMENT ---

  static Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data pesanan');
      }
    } catch (e) {
      print('Error ApiService (getOrders): $e');
      return [];
    }
  }

  static Future<bool> updateOrderStatus(String id, String status, {String? reason}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/$id/status'),
        headers: _headers,
        body: jsonEncode({
          'status': status,
          'reason': reason,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // --- SUMMARY & REPORTS ---

  static Future<Map<String, dynamic>> getSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/summary'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memuat ringkasan');
      }
    } catch (e) {
      print('Error ApiService (getSummary): $e');
      return {
        'total_earnings': 0.0,
        'total_products_sold': 0,
        'new_orders_count': 0,
        'earnings_increase': 0.0,
        'balance': 0.0,
        'month_earnings': 0.0,
        'total_orders': 0,
        'business_name': '',
      };
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memuat profil');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Ambil Aktivitas Terbaru
  static Future<List<Order>> getRecentActivities() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activities'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => Order.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}