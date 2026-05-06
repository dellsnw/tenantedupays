import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models/order.dart';
import 'saldo_page.dart';
import 'order_list_page.dart' show formatCurrency;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color _primary = Color(0xFF00BCC9);
  static const Color _deepTeal = Color(0xFF008D98);
  static const Color _ink = Color(0xFF173A43);
  static const Color _muted = Color(0xFF78909C);
  static const Color _surface = Color(0xFFF5FBFC);

  List<Order> _activities = [];
  double _totalEarnings = 0;
  int _productsSold = 0;
  int _newOrders = 0;
  double _increase = 0;
  String _businessName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final summary = await ApiService.getSummary();
      final activities = await ApiService.getRecentActivities();
      
      setState(() {
        _totalEarnings = double.tryParse(summary['total_earnings']?.toString() ?? '0') ?? 0;
        _productsSold = summary['total_products_sold'] ?? 0;
        _newOrders = summary['new_orders_count'] ?? 0;
        _increase = double.tryParse(summary['earnings_increase']?.toString() ?? '0') ?? 0;
        _businessName = summary['business_name'] ?? '';
        _activities = activities;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading home data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),
                const SizedBox(height: 18),
                _buildHeroCard(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _statCard(Icons.inventory_2_outlined, '$_productsSold', 'Produk Terjual'),
                    const SizedBox(width: 12),
                    _statCard(Icons.shopping_bag_outlined, '$_newOrders', 'Pesanan Baru'),
                  ],
                ),
                const SizedBox(height: 24),
                _sectionHeader('Aktivitas Hari Ini', 'Lihat Semua'),
                const SizedBox(height: 10),
                if (_activities.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_outlined, color: Color(0xFFCFD8DC), size: 48),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada pesanan masuk',
                            style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._activities.map(_activityItem),
                const SizedBox(height: 24),
                const Text(
                  'Menu Terlaris',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                _bestSellerCard(isEmpty: true), // Sementara diset true karena data belum dari API
                const SizedBox(height: 18),
                _tipCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _softShadow,
              ),
              child: Image.asset('assets/images/edupays.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Beranda',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Kelola tenant hari ini',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _iconButton(Icons.notifications_none_rounded),
            const SizedBox(width: 8),
            _iconButton(
              Icons.settings_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BusinessProfilePage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00D6E4),
            _primary,
            _deepTeal,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.28),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Halo,',
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _businessName.isNotEmpty ? _businessName : 'Tenant',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Hari Ini',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Total Pendapatan',
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            _totalEarnings > 0 ? formatCurrency(_totalEarnings) : 'Rp -',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          if (_totalEarnings == 0)
            const Text(
              'Saldo akan muncul setelah ada transaksi selesai',
              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${_increase >= 0 ? "+" : ""}${_increase.toStringAsFixed(1)}% dari kemarin',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: _softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: _deepTeal, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: _ink, fontSize: 17, fontWeight: FontWeight.w700)),
        TextButton(onPressed: () {}, child: Text(action, style: const TextStyle(color: _primary, fontWeight: FontWeight.w700))),
      ],
    );
  }

  Widget _activityItem(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: Color(0xFFF1F4F7), shape: BoxShape.circle),
            child: const Icon(Icons.shopping_bag_outlined, color: _primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.customerName, style: const TextStyle(color: _ink, fontWeight: FontWeight.w700)),
                Text(order.summary, style: const TextStyle(color: _muted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(formatCurrency(order.totalPrice), style: const TextStyle(color: _ink, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _bestSellerCard({bool isEmpty = false}) {
    if (isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: _softShadow,
          border: Border.all(color: const Color(0xFFF1F4F7)),
        ),
        child: const Column(
          children: [
            Text(
              'Belum Ada Menu Terlaris',
              style: TextStyle(color: _ink, fontSize: 15, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 6),
            Text(
              'Menu terlaris akan muncul setelah ada transaksi',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: _softShadow),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.star_rounded, color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Menu Paling Laku', style: TextStyle(color: _muted, fontSize: 12)),
                Text('Nasi Goreng Spesial', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Terjual', style: TextStyle(color: _muted, fontSize: 12)),
              Text('128 Porsi', style: TextStyle(color: _primary, fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEAFBFD), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFC9F2F6))),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: _primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tips: Menu minuman dingin lebih laku di siang hari.',
              style: TextStyle(color: _ink, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: _softShadow),
        child: Icon(icon, color: _ink, size: 22),
      ),
    );
  }

  List<BoxShadow> get _softShadow => [
        BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
      ];
}
