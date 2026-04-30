import 'package:flutter/material.dart';

const Color _teal = Color(0xFF00B8C8);
const Color _bg = Color(0xFFF5F8FA);
const Color _text = Color(0xFF172B3A);

class ReportPeriodData {
  final String period;
  final String monthLabel;
  final int revenue;
  final int transactions;
  final int dailyAverage;
  final double revenueGrowth;
  final double transactionGrowth;
  final double averageGrowth;
  final List<double> chartValues;

  const ReportPeriodData({
    required this.period,
    required this.monthLabel,
    required this.revenue,
    required this.transactions,
    required this.dailyAverage,
    required this.revenueGrowth,
    required this.transactionGrowth,
    required this.averageGrowth,
    required this.chartValues,
  });
}

class ProductReport {
  final String name;
  final String category;
  final int sold;
  final int revenue;
  final Color color;
  final IconData icon;

  const ProductReport({
    required this.name,
    required this.category,
    required this.sold,
    required this.revenue,
    required this.color,
    required this.icon,
  });
}

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String _selectedPeriod = 'Bulan Ini';

  static const List<ReportPeriodData> _periods = [
    ReportPeriodData(
      period: 'Bulan Ini',
      monthLabel: 'Juni 2024',
      revenue: 12890000,
      transactions: 42,
      dailyAverage: 300000,
      revenueGrowth: 12.5,
      transactionGrowth: 8.2,
      averageGrowth: -4.1,
      chartValues: [4.4, 5.1, 4.8, 6.1, 5.9, 7.5],
    ),
    ReportPeriodData(
      period: '30 Hari Terakhir',
      monthLabel: '30 Hari Terakhir',
      revenue: 11240000,
      transactions: 38,
      dailyAverage: 274000,
      revenueGrowth: 7.8,
      transactionGrowth: 4.6,
      averageGrowth: 2.2,
      chartValues: [3.9, 4.4, 4.2, 5.2, 5.5, 6.4],
    ),
    ReportPeriodData(
      period: 'Tahun Ini',
      monthLabel: '2024',
      revenue: 68250000,
      transactions: 248,
      dailyAverage: 379000,
      revenueGrowth: 18.4,
      transactionGrowth: 11.8,
      averageGrowth: 5.7,
      chartValues: [7.5, 8.2, 9.8, 11.3, 13.2, 17.4],
    ),
  ];

  static const List<ProductReport> _products = [
    ProductReport(
      name: 'Kopi Susu Gula Aren',
      category: 'Minuman',
      sold: 40,
      revenue: 4000000,
      color: Color(0xFFB2DFDB),
      icon: Icons.coffee_outlined,
    ),
    ProductReport(
      name: 'Nasi Goreng Spesial',
      category: 'Makanan',
      sold: 10,
      revenue: 500000,
      color: Color(0xFFFFD180),
      icon: Icons.rice_bowl_outlined,
    ),
    ProductReport(
      name: 'Croissant Almond',
      category: 'Pastry',
      sold: 420,
      revenue: 1500000,
      color: Color(0xFFD1C4E9),
      icon: Icons.bakery_dining_outlined,
    ),
    ProductReport(
      name: 'Es Teh Manis',
      category: 'Minuman',
      sold: 90,
      revenue: 900000,
      color: Color(0xFFBBDEFB),
      icon: Icons.local_drink_outlined,
    ),
    ProductReport(
      name: 'Mie Ayam Bakso',
      category: 'Makanan',
      sold: 24,
      revenue: 528000,
      color: Color(0xFFC8E6C9),
      icon: Icons.ramen_dining_outlined,
    ),
  ];

  ReportPeriodData get _data =>
      _periods.firstWhere((item) => item.period == _selectedPeriod);

  @override
  Widget build(BuildContext context) {
    final data = _data;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 20,
        title: const Text(
          'Laporan Penjualan',
          style: TextStyle(
            color: _text,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            color: const Color(0xFF617484),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            color: const Color(0xFF617484),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 112),
          children: [
            _DateFilterBar(label: data.monthLabel),
            const SizedBox(height: 14),
            _PeriodFilter(
              selected: _selectedPeriod,
              onChanged: (value) => setState(() => _selectedPeriod = value),
            ),
            const SizedBox(height: 18),
            _RevenueCard(data: data),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Total Transaksi',
                    value: '${data.transactions}',
                    icon: Icons.shopping_cart_outlined,
                    growth: data.transactionGrowth,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: 'Rata-rata Harian',
                    value: _formatCurrency(data.dailyAverage),
                    icon: Icons.show_chart_rounded,
                    growth: data.averageGrowth,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _InsightBox(),
            const SizedBox(height: 18),
            _ChartCard(values: data.chartValues),
            const SizedBox(height: 18),
            _ProductHeader(
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductReportListPage(
                      products: _products,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _TopProductsCard(products: _products.take(3).toList()),
          ],
        ),
      ),
    );
  }
}

class _DateFilterBar extends StatelessWidget {
  final String label;

  const _DateFilterBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, color: Color(0xFF617484), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _text,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_alt_outlined, size: 17),
          label: const Text('Filter'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _teal,
            side: const BorderSide(color: Color(0xFFBFE5EA)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class _PeriodFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PeriodFilter({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const periods = ['Bulan Ini', '30 Hari Terakhir', 'Tahun Ini'];

    return Row(
      children: [
        for (final period in periods) ...[
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => onChanged(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected == period ? _teal : const Color(0xFFF0F4F6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected == period
                        ? Colors.white
                        : const Color(0xFF4E5B66),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          if (period != periods.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final ReportPeriodData data;

  const _RevenueCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -22,
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: _teal.withValues(alpha: 0.08),
              size: 110,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7F3F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: _teal,
                  size: 19,
                ),
              ),
              const Spacer(),
              _GrowthBadge(value: data.revenueGrowth),
            ],
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pendapatan Bulan Ini',
                  style: TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatCurrency(data.revenue),
                  style: const TextStyle(
                    color: _text,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
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

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final double growth;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.growth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _teal, size: 23),
              const Spacer(),
              _GrowthBadge(value: growth),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF617484),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: _text,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthBadge extends StatelessWidget {
  final double value;

  const _GrowthBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? const Color(0xFF22A86B) : const Color(0xFFE05252);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${positive ? '+' : ''}${value.toStringAsFixed(1)}%',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E3EA)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.trending_up_rounded, color: _text, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Insight: ',
                style: TextStyle(fontWeight: FontWeight.w900),
                children: [
                  TextSpan(
                    text:
                        'Penjualan Anda naik 12% dibanding bulan lalu. Kopi Susu Aren tetap menjadi pendorong utama pendapatan.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              style: TextStyle(
                color: _text,
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final List<double> values;

  const _ChartCard({required this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 322,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tren Penjualan Bulanan',
            style: TextStyle(
              color: _text,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Estimasi pertumbuhan semester 1 2024',
            style: TextStyle(
              color: Color(0xFF617484),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: CustomPaint(
              painter: _SalesLineChartPainter(values),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  final VoidCallback onSeeAll;

  const _ProductHeader({required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Produk Terlaris',
            style: TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text(
            'Lihat Semua',
            style: TextStyle(
              color: _teal,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopProductsCard extends StatelessWidget {
  final List<ProductReport> products;

  const _TopProductsCard({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E9EE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < products.length; index++) ...[
            _ProductItem(product: products[index], rank: index + 1),
            if (index != products.length - 1)
              const Divider(height: 1, color: Color(0xFFE3E9EE)),
          ],
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductReport product;
  final int rank;

  const _ProductItem({required this.product, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: product.color.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(product.icon, color: _text, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.category} • ${product.sold} terjual',
                  style: const TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(product.revenue),
                style: const TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.north_east_rounded, size: 13, color: _text),
                  const SizedBox(width: 3),
                  Text(
                    'Top $rank',
                    style: const TextStyle(
                      color: _text,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductReportListPage extends StatelessWidget {
  final List<ProductReport> products;

  const ProductReportListPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: _text,
        ),
        titleSpacing: 0,
        title: const Text(
          'Semua Produk Terlaris',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF173241).withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _ProductItem(product: products[index], rank: index + 1),
            );
          },
        ),
      ),
    );
  }
}

class _SalesLineChartPainter extends CustomPainter {
  final List<double> values;

  _SalesLineChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 44.0;
    const bottomPadding = 26.0;
    const topPadding = 8.0;
    const rightPadding = 6.0;
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;
    final maxValue = values.reduce((a, b) => a > b ? a : b).clamp(8.0, 20.0);
    final labels = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'];
    final gridPaint = Paint()
      ..color = const Color(0xFFE3E9EE)
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var i = 0; i <= 4; i++) {
      final y = topPadding + chartHeight * i / 4;
      _drawDashedLine(
        canvas,
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      final value = ((4 - i) * maxValue / 4).round();
      textPainter.text = TextSpan(
        text: '${value}M',
        style: const TextStyle(
          color: Color(0xFF8A98A5),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 7));
    }

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = leftPadding + (chartWidth * i / (values.length - 1));
      final y = topPadding + chartHeight - (values[i] / maxValue * chartHeight);
      points.add(Offset(x, y));

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Color(0xFF617484),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 17),
      );
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      linePath.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final areaPath = Path.from(linePath)
      ..lineTo(points.last.dx, topPadding + chartHeight)
      ..lineTo(points.first.dx, topPadding + chartHeight)
      ..close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          _teal.withValues(alpha: 0.22),
          _teal.withValues(alpha: 0.03),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, topPadding, size.width, chartHeight));

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(
      linePath,
      Paint()
        ..color = _teal
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    var x = start.dx;
    while (x < end.dx) {
      canvas.drawLine(Offset(x, start.dy), Offset(x + dashWidth, end.dy), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _SalesLineChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

String _formatCurrency(int value) {
  return 'Rp ${value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      )}';
}
