import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models/order.dart';
import 'order_detail_page.dart';

const Color kOrderTeal = Color(0xFF00B8C8);
const Color kOrderBg = Color(0xFFF5F8FA);
const Color kOrderText = Color(0xFF172B3A);

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  int _selectedTab = 0;
  int _historyLimit = 3;
  List<Order> allOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getOrders();
    setState(() {
      allOrders = data;
      _isLoading = false;
    });
  }

  List<Order> get _activeOrders => allOrders
      .where(
        (order) =>
            order.status == 'Menunggu' ||
            order.status == 'Diproses' ||
            order.status == 'Siap Diambil',
      )
      .toList();

  List<Order> get _historyOrders => allOrders
      .where((order) => order.status == 'Selesai' || order.status == 'Dibatalkan')
      .toList();

  @override
  Widget build(BuildContext context) {
    final activeCount = _activeOrders.length;

    return Scaffold(
      backgroundColor: kOrderBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 20,
        title: const Text(
          'Daftar Pesanan',
          style: TextStyle(
            color: kOrderText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_outlined, size: 20),
            color: const Color(0xFF617484),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: kOrderTeal))
            : Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
                    child: Row(
                      children: [
                        _FilterChipButton(
                          label: 'Aktif ($activeCount)',
                          selected: _selectedTab == 0,
                          onTap: () => setState(() => _selectedTab = 0),
                        ),
                        const SizedBox(width: 8),
                        _FilterChipButton(
                          label: 'Selesai',
                          selected: _selectedTab == 1,
                          onTap: () => setState(() => _selectedTab = 1),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _fetchOrders,
                      color: kOrderTeal,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _selectedTab == 0
                            ? _ActiveOrderList(
                                key: const ValueKey('active'),
                                orders: _activeOrders,
                              )
                            : _HistoryOrderList(
                                key: const ValueKey('history'),
                                orders: _historyOrders.take(_historyLimit).toList(),
                                canShowMore: _historyLimit < _historyOrders.length,
                                onShowMore: () => setState(() => _historyLimit += 3),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ActiveOrderList extends StatelessWidget {
  final List<Order> orders;

  const _ActiveOrderList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _EmptyOrders(message: 'Belum ada pesanan aktif');
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 104),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailPage(order: order),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Avatar(order: order),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.customerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: kOrderText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              _StatusBadge(status: order.status),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            order.id,
                            style: const TextStyle(
                              color: Color(0xFF8A98A5),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.restaurant_menu,
                      size: 16,
                      color: Color(0xFF617484),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.menuName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kOrderText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      formatCurrency(order.totalPrice),
                      style: const TextStyle(
                        color: kOrderTeal,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (order.note != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 15,
                        color: Color(0xFF8A98A5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.note!,
                          style: const TextStyle(
                            color: Color(0xFF7A8895),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE9EEF2)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: Color(0xFF617484),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatRelativeTime(order.orderTime),
                      style: const TextStyle(
                        color: Color(0xFF617484),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF9AA7B2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HistoryOrderList extends StatelessWidget {
  final List<Order> orders;
  final bool canShowMore;
  final VoidCallback onShowMore;

  const _HistoryOrderList({
    super.key,
    required this.orders,
    required this.canShowMore,
    required this.onShowMore,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _EmptyOrders(message: 'Riwayat pesanan masih kosong');
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 104),
      itemCount: orders.length + (canShowMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == orders.length) {
          return OutlinedButton(
            onPressed: onShowMore,
            style: OutlinedButton.styleFrom(
              foregroundColor: kOrderTeal,
              side: const BorderSide(color: kOrderTeal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: const Text(
              'Lihat Lebih Banyak',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          );
        }

        final order = orders[index];
        final isCanceled = order.status == 'Dibatalkan';

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailPage(order: order),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Avatar(order: order),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: const TextStyle(
                              color: kOrderText,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF617484),
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      formatCurrency(order.totalPrice),
                      style: const TextStyle(
                        color: kOrderText,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    if (isCanceled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tidak Masuk Laporan',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      )
                    else
                      Text(
                        formatRelativeTime(order.orderTime),
                        style: const TextStyle(
                          color: Color(0xFF8A98A5),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kOrderTeal : const Color(0xFFF0F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF617484),
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = statusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors.foreground,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final Order order;

  const _Avatar({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          order.avatarImagePath,
          width: 42,
          height: 42,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  final String message;

  const _EmptyOrders({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFFB5C1C9),
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF617484),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF173241).withValues(alpha: 0.07),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

({Color background, Color foreground}) statusColors(String status) {
  switch (status) {
    case 'Menunggu':
      return (
        background: const Color(0xFFF0F2F4),
        foreground: const Color(0xFF617484),
      );
    case 'Diproses':
      return (
        background: const Color(0xFFE5F7FA),
        foreground: kOrderTeal,
      );
    case 'Siap Diambil':
      return (
        background: const Color(0xFFE8F8EE),
        foreground: const Color(0xFF29A36A),
      );
    case 'Selesai':
      return (
        background: const Color(0xFFE8F8EE),
        foreground: const Color(0xFF22A86B),
      );
    case 'Dibatalkan':
      return (
        background: const Color(0xFFFFEBEE),
        foreground: const Color(0xFFE53935),
      );
    default:
      return (
        background: const Color(0xFFF0F2F4),
        foreground: const Color(0xFF617484),
      );
  }
}

String formatCurrency(double value) {
  return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      )}';
}

String formatRelativeTime(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Baru saja';
  }
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} menit lalu';
  }
  if (difference.inHours < 24) {
    return '${difference.inHours} jam lalu';
  }
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

String formatClock(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')} WIB';
}

String formatDateTime(DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}/'
      '${dateTime.month.toString().padLeft(2, '0')}/'
      '${dateTime.year} - ${formatClock(dateTime)}';
}
