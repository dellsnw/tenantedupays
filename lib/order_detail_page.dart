import 'package:flutter/material.dart';

import 'order_list_page.dart';

const double _serviceFee = 2000;

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late String _status;
  late String? _cancelReason;
  late DateTime? _cancelTime;
  DateTime? _finishedAt;

  bool get _isCanceled => _status == 'Dibatalkan';
  bool get _isFinished => _status == 'Selesai';
  bool get _canCancel => _status == 'Menunggu' || _status == 'Diproses';
  bool get _showActions => !_isCanceled && !_isFinished;

  double get _subtotal => widget.order.totalPrice;
  double get _total => _subtotal + _serviceFee;
  DateTime get _pickupTime => widget.order.orderTime.add(
        const Duration(minutes: 30),
      );

  @override
  void initState() {
    super.initState();
    _status = widget.order.status;
    _cancelReason = widget.order.cancelReason;
    _cancelTime = widget.order.cancelTime;
    if (_status == 'Selesai') {
      _finishedAt = widget.order.orderTime.add(const Duration(minutes: 42));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOrderBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: kOrderText,
        ),
        titleSpacing: 0,
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(
            color: kOrderText,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            color: const Color(0xFF617484),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 14, 16, _showActions ? 176 : 104),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _buildStatusBody(),
          ),
        ),
      ),
      bottomNavigationBar: _showActions ? _ActionPanel(state: this) : null,
    );
  }

  Widget _buildStatusBody() {
    if (_isCanceled) {
      return _CanceledBody(
        key: const ValueKey('canceled'),
        order: widget.order,
        reason: _cancelReason,
        cancelTime: _cancelTime,
        subtotal: _subtotal,
        total: _total,
      );
    }
    if (_isFinished) {
      return _FinishedBody(
        key: const ValueKey('finished'),
        order: widget.order,
        finishedAt: _finishedAt ?? DateTime.now(),
        subtotal: _subtotal,
        total: _total,
      );
    }
    if (_status == 'Siap Diambil') {
      return _ReadyBody(
        key: const ValueKey('ready'),
        order: widget.order,
        pickupTime: _pickupTime,
        subtotal: _subtotal,
        total: _total,
      );
    }
    return _ProcessBody(
      key: const ValueKey('process'),
      order: widget.order,
      status: _status == 'Menunggu' ? 'Diproses' : _status,
      pickupTime: _pickupTime,
      subtotal: _subtotal,
      total: _total,
    );
  }

  void _advanceStatus() {
    setState(() {
      if (_status == 'Menunggu' || _status == 'Diproses') {
        _status = 'Siap Diambil';
      } else if (_status == 'Siap Diambil') {
        _status = 'Selesai';
        _finishedAt = DateTime.now();
      }
    });
  }

  Future<void> _showCancelDialog() async {
    if (!_canCancel) {
      return;
    }

    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFE53935),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Batalkan Pesanan?',
                  style: TextStyle(
                    color: kOrderText,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tindakan ini tidak dapat dibatalkan. Pesanan akan dipindahkan ke riwayat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _CompactSummary(order: widget.order),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  minLines: 3,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'stok habis atau kantin tutup',
                    hintStyle: const TextStyle(color: Color(0xFFA7B2BA)),
                    filled: true,
                    fillColor: const Color(0xFFF6F9FA),
                    contentPadding: const EdgeInsets.all(12),
                    border: _inputBorder(const Color(0xFFE1E8ED)),
                    enabledBorder: _inputBorder(const Color(0xFFE1E8ED)),
                    focusedBorder: _inputBorder(kOrderTeal),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final value = controller.text.trim();
                      Navigator.pop(
                        context,
                        value.isEmpty ? 'Stok habis atau kantin tutup' : value,
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Ya, Batalkan Pesanan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      color: Color(0xFF617484),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();

    if (reason == null || !mounted) {
      return;
    }

    setState(() {
      _status = 'Dibatalkan';
      _cancelReason = reason;
      _cancelTime = DateTime.now();
    });
  }
}

class _ProcessBody extends StatelessWidget {
  final Order order;
  final String status;
  final DateTime pickupTime;
  final double subtotal;
  final double total;

  const _ProcessBody({
    super.key,
    required this.order,
    required this.status,
    required this.pickupTime,
    required this.subtotal,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OrderHeaderCard(
          label: 'ID Pesanan',
          value: order.id,
          status: status,
          valueSize: 16,
        ),
        const SizedBox(height: 14),
        _HighlightBox(
          icon: Icons.calendar_month_outlined,
          title: 'Estimasi Pengambilan',
          value: 'Hari ini, ${formatClock(pickupTime)}',
          background: const Color(0xFFFFFAEA),
          border: const Color(0xFFF1E1B7),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.restaurant_menu_rounded,
                title: 'Rincian Menu',
              ),
              const SizedBox(height: 16),
              _ItemLine(order: order),
              if (order.secondMenuName != null) ...[
                const Divider(height: 26, color: Color(0xFFE9EEF2)),
                _ItemLine(
                  order: order,
                  secondItem: true,
                ),
              ],
              const Divider(height: 30, color: Color(0xFFE9EEF2)),
              _PaymentSummary(subtotal: subtotal, total: total),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _NoteBox(
          text:
              'Pastikan semua item tersedia sebelum melanjutkan sebagai Sedang Dibuat.',
        ),
      ],
    );
  }
}

class _ReadyBody extends StatelessWidget {
  final Order order;
  final DateTime pickupTime;
  final double subtotal;
  final double total;

  const _ReadyBody({
    super.key,
    required this.order,
    required this.pickupTime,
    required this.subtotal,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OrderHeaderCard(
          label: 'Nomor Pesanan',
          value: order.id.replaceFirst('ORD-202304-', 'ORD-9928'),
          status: 'Siap Diambil',
          valueSize: 22,
        ),
        const SizedBox(height: 14),
        _HighlightBox(
          icon: Icons.timer_outlined,
          title: 'Waktu Pengambilan',
          value: 'Hari ini, pukul ${formatClock(pickupTime).replaceAll(' WIB', '')}',
          background: const Color(0xFFFFFAEA),
          border: const Color(0xFFF1E1B7),
        ),
        const SizedBox(height: 14),
        _CustomerPickupCard(order: order),
        const SizedBox(height: 14),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.shopping_bag_outlined,
                title: 'Ringkasan Item',
              ),
              const SizedBox(height: 16),
              _SimpleItemLine(order: order),
              if (order.secondMenuName != null) ...[
                const SizedBox(height: 14),
                _SimpleItemLine(order: order, secondItem: true),
              ],
              const Divider(height: 30, color: Color(0xFFE9EEF2)),
              _PaymentSummary(subtotal: subtotal, total: total),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _NoteBox(
          text:
              'Pastikan pesanan sudah diambil pelanggan sebelum menyelesaikan.',
        ),
      ],
    );
  }
}

class _FinishedBody extends StatelessWidget {
  final Order order;
  final DateTime finishedAt;
  final double subtotal;
  final double total;

  const _FinishedBody({
    super.key,
    required this.order,
    required this.finishedAt,
    required this.subtotal,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F8EE),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFC8EFD9)),
          ),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const _StatusPill(status: 'Selesai'),
              const SizedBox(height: 10),
              const Text(
                'Pesanan Selesai',
                style: TextStyle(
                  color: kOrderText,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Transaksi ini telah berhasil diselesaikan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF617484),
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _SectionCard(
          child: _InfoRow(
            label: 'Waktu Selesai',
            value: formatDateTime(finishedAt),
          ),
        ),
        const SizedBox(height: 14),
        _CustomerPickupCard(order: order, compact: true),
        const SizedBox(height: 14),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.payments_outlined,
                title: 'Rincian Item',
              ),
              const SizedBox(height: 16),
              _SimpleItemLine(order: order),
              if (order.secondMenuName != null) ...[
                const Divider(height: 26, color: Color(0xFFE9EEF2)),
                _SimpleItemLine(order: order, secondItem: true),
              ],
              const Divider(height: 30, color: Color(0xFFE9EEF2)),
              _PaymentSummary(subtotal: subtotal, total: total),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFE5FA)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_outlined, color: kOrderTeal, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Sistem',
                      style: TextStyle(
                        color: kOrderTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Dana telah diteruskan ke saldo toko Anda. Terima kasih telah melayani pelanggan.',
                      style: TextStyle(
                        color: Color(0xFF617484),
                        height: 1.45,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Pesanan tidak dapat diubah kembali.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF617484),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CanceledBody extends StatelessWidget {
  final Order order;
  final String? reason;
  final DateTime? cancelTime;
  final double subtotal;
  final double total;

  const _CanceledBody({
    super.key,
    required this.order,
    required this.reason,
    required this.cancelTime,
    required this.subtotal,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFCDD2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.cancel_outlined, color: Color(0xFFE53935)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pesanan Dibatalkan',
                      style: TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order ID: ${order.id}',
                      style: const TextStyle(
                        color: Color(0xFF9E4B4B),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const _StatusPill(status: 'Dibatalkan'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          borderColor: const Color(0xFFFFCDD2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.info_outline_rounded,
                title: 'Informasi Pembatalan',
                color: Color(0xFFE53935),
              ),
              const SizedBox(height: 14),
              _InfoRow(
                label: 'Alasan',
                value: reason ?? 'Tidak ada alasan',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                label: 'Waktu Pembatalan',
                value: cancelTime == null ? '-' : formatDateTime(cancelTime!),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.receipt_long_outlined,
                title: 'Ringkasan Pesanan',
              ),
              const SizedBox(height: 16),
              _SimpleItemLine(order: order),
              if (order.secondMenuName != null) ...[
                const SizedBox(height: 14),
                _SimpleItemLine(order: order, secondItem: true),
              ],
              const Divider(height: 30, color: Color(0xFFE9EEF2)),
              _PaymentSummary(subtotal: subtotal, total: total),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _NoteBox(
          icon: Icons.block_rounded,
          iconColor: Color(0xFFE53935),
          text: 'Pesanan tidak masuk ke laporan pendapatan.',
        ),
      ],
    );
  }
}

class _ActionPanel extends StatelessWidget {
  final _OrderDetailPageState state;

  const _ActionPanel({required this.state});

  @override
  Widget build(BuildContext context) {
    final isReady = state._status == 'Siap Diambil';
    final label = isReady ? 'Tandai Selesai' : 'Tandai Sedang Dibuat';
    final note = isReady
        ? 'Pastikan pesanan telah diserahkan ke pelanggan sebelum menekan tombol selesai.'
        : 'Pastikan semua item tersedia sebelum melanjutkan.';

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 18,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: state._advanceStatus,
                icon: Icon(
                  isReady
                      ? Icons.check_circle_outline_rounded
                      : Icons.local_fire_department_outlined,
                  size: 18,
                ),
                label: Text(label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrderTeal,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: kOrderTeal.withValues(alpha: 0.24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            if (state._canCancel) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: state._showCancelDialog,
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Batalkan Pesanan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    side: const BorderSide(color: Color(0xFFE53935)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              note,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF617484),
                fontSize: 11,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  final String label;
  final String value;
  final String status;
  final double valueSize;

  const _OrderHeaderCard({
    required this.label,
    required this.value,
    required this.status,
    required this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 11,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  value,
                  style: TextStyle(
                    color: kOrderText,
                    fontSize: valueSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          _StatusPill(status: status),
        ],
      ),
    );
  }
}

class _HighlightBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color background;
  final Color border;

  const _HighlightBox({
    required this.icon,
    required this.title,
    required this.value,
    required this.background,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, color: kOrderTeal, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kOrderText,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerPickupCard extends StatelessWidget {
  final Order order;
  final bool compact;

  const _CustomerPickupCard({required this.order, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Row(
        children: [
          _Avatar(order: order, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(
                    color: kOrderText,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  compact ? '#${order.id}' : '0812-3456-7890',
                  style: const TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (!compact) ...[
            _CircleIconButton(icon: Icons.phone_outlined, onTap: () {}),
            const SizedBox(width: 8),
            _CircleIconButton(icon: Icons.chat_bubble_outline, onTap: () {}),
          ] else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'TAKE AWAY',
                style: TextStyle(
                  color: Color(0xFF4E5B66),
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemLine extends StatelessWidget {
  final Order order;
  final bool secondItem;

  const _ItemLine({required this.order, this.secondItem = false});

  @override
  Widget build(BuildContext context) {
    final name = secondItem ? order.secondMenuName! : order.menuName;
    final qty = secondItem ? order.secondQuantity : order.quantity;
    final price = secondItem ? order.secondMenuPrice! : order.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F7FA),
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            '$qty',
            style: const TextStyle(
              color: kOrderTeal,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: kOrderText,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (!secondItem && order.note != null) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.notes_rounded,
                        size: 14,
                        color: Color(0xFF617484),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '"${order.note!}"',
                          style: const TextStyle(
                            color: Color(0xFF617484),
                            fontSize: 12,
                            height: 1.35,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          formatCurrency(price * qty),
          style: const TextStyle(
            color: kOrderText,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _SimpleItemLine extends StatelessWidget {
  final Order order;
  final bool secondItem;

  const _SimpleItemLine({required this.order, this.secondItem = false});

  @override
  Widget build(BuildContext context) {
    final name = secondItem ? order.secondMenuName! : order.menuName;
    final qty = secondItem ? order.secondQuantity : order.quantity;
    final price = secondItem ? order.secondMenuPrice! : order.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: kOrderText,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: $qty',
                style: const TextStyle(
                  color: Color(0xFF617484),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Text(
          formatCurrency(price * qty),
          style: const TextStyle(
            color: kOrderText,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  final double subtotal;
  final double total;

  const _PaymentSummary({required this.subtotal, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PriceRow(label: 'Subtotal', value: formatCurrency(subtotal)),
        const SizedBox(height: 10),
        _PriceRow(label: 'Biaya Layanan', value: formatCurrency(_serviceFee)),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Total Bayar',
                style: TextStyle(
                  color: kOrderText,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              formatCurrency(total),
              style: const TextStyle(
                color: kOrderTeal,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF617484),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF4F5E6B),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _NoteBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const _NoteBox({
    required this.text,
    this.icon = Icons.info_outline_rounded,
    this.iconColor = const Color(0xFF617484),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E8EE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF617484),
                fontSize: 12,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactSummary extends StatelessWidget {
  final Order order;

  const _CompactSummary({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.restaurant_menu_rounded, size: 17, color: kOrderTeal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              order.summary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kOrderText,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;

  const _SectionCard({required this.child, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor ?? const Color(0xFFE9EEF2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionTitle({
    required this.icon,
    required this.title,
    this.color = kOrderTeal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color == kOrderTeal ? kOrderText : color,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = statusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), size: 14, color: colors.foreground),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: colors.foreground,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final Order order;
  final double size;

  const _Avatar({required this.order, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: order.avatarColor.withValues(alpha: 0.22),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        order.customerName.substring(0, 1).toUpperCase(),
        style: TextStyle(
          color: order.avatarColor,
          fontWeight: FontWeight.w900,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E8EE)),
        ),
        child: Icon(icon, color: kOrderText, size: 18),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A98A5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: kOrderText,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

IconData _statusIcon(String status) {
  switch (status) {
    case 'Menunggu':
      return Icons.schedule_rounded;
    case 'Diproses':
      return Icons.timer_outlined;
    case 'Siap Diambil':
      return Icons.shopping_bag_outlined;
    case 'Selesai':
      return Icons.check_circle_outline_rounded;
    case 'Dibatalkan':
      return Icons.cancel_outlined;
    default:
      return Icons.info_outline_rounded;
  }
}

OutlineInputBorder _inputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
}
