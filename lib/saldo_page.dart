import 'package:flutter/material.dart';

const Color _teal = Color(0xFF00B8C8);
const Color _bg = Color(0xFFF5F8FA);
const Color _text = Color(0xFF172B3A);

class SaldoPage extends StatelessWidget {
  const SaldoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 20,
        title: const Text(
          'Saldo',
          style: TextStyle(
            color: _text,
            fontSize: 20,
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BusinessProfilePage(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
            color: const Color(0xFF617484),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
          children: [
            const _BalanceCard(),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _IncomeSummaryCard(
                    label: 'Hari Ini',
                    amount: 345000,
                    icon: Icons.trending_up_rounded,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _IncomeSummaryCard(
                    label: 'Bulan Ini',
                    amount: 5890000,
                    icon: Icons.calendar_today_outlined,
                    tinted: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WithdrawBalancePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.call_made_rounded, size: 20),
                label: const Text('Tarik Saldo ke Rekening'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Penarikan akan diproses maksimal 1x24 jam ke rekening yang terdaftar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF617484),
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 22),
            const _SectionHeader(),
            const SizedBox(height: 12),
            const _WithdrawalHistoryCard(),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Lihat Semua Riwayat',
                style: TextStyle(
                  color: _teal,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 158,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF0CBBC9), Color(0xFF03AFC1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _teal.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -22,
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 118,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            right: 20,
            top: 34,
            child: Container(
              width: 88,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Saldo Tersedia',
                style: TextStyle(
                  color: Color(0xCCFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Rp 5.890.000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              SizedBox(height: 16),
              _BalancePill(),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        'Siap untuk ditarik ke rekening',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _IncomeSummaryCard extends StatelessWidget {
  final String label;
  final int amount;
  final IconData icon;
  final bool tinted;

  const _IncomeSummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    this.tinted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tinted ? const Color(0xFFEAF3FB) : Colors.white,
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: tinted
                      ? const Color(0xFFD7EBFF)
                      : const Color(0xFFF1F4F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _teal, size: 18),
              ),
              const Spacer(),
              const Icon(
                Icons.north_east_rounded,
                color: Color(0xFFB5C1C9),
                size: 18,
              ),
            ],
          ),
          const Spacer(),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF617484),
              fontSize: 12,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(amount),
            style: const TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.history_rounded, color: _teal, size: 18),
        SizedBox(width: 8),
        Text(
          'Riwayat Penarikan',
          style: TextStyle(
            color: Color(0xFF617484),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _WithdrawalHistoryCard extends StatelessWidget {
  const _WithdrawalHistoryCard();

  static const items = [
    ('24 Okt 2023, 14:20', 1500000),
    ('20 Okt 2023, 09:15', 2000000),
    ('15 Okt 2023, 11:45', 500000),
    ('08 Okt 2023, 16:30', 1250000),
    ('02 Okt 2023, 10:00', 800000),
    ('28 Sep 2023, 08:20', 1100000),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EEF2)),
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
          for (var index = 0; index < items.length; index++) ...[
            _WithdrawalItem(
              date: items[index].$1,
              amount: items[index].$2,
            ),
            if (index != items.length - 1)
              const Divider(height: 1, color: Color(0xFFE3E9EE)),
          ],
        ],
      ),
    );
  }
}

class _WithdrawalItem extends StatelessWidget {
  final String date;
  final int amount;

  const _WithdrawalItem({required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF22A86B),
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Penarikan Saldo',
                  style: TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
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
                _formatCurrency(amount),
                style: const TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EE),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    color: Color(0xFF22A86B),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WithdrawBalancePage extends StatelessWidget {
  const WithdrawBalancePage({super.key});

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
          'Tarik Saldo',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo dapat ditarik',
                    style: TextStyle(
                      color: Color(0xFF617484),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rp 5.890.000',
                    style: TextStyle(
                      color: _teal,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 16),
                  _BankInfoTile(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _WithdrawInfoBox(),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permintaan penarikan berhasil dibuat'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.send_outlined, size: 18),
                label: const Text('Ajukan Penarikan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
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

class _BankInfoTile extends StatelessWidget {
  const _BankInfoTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.account_balance_outlined, color: _teal),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BCA - 1234567890',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'a.n. Kantin Kampus Sejahtera',
                  style: TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _WithdrawInfoBox extends StatelessWidget {
  const _WithdrawInfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAFBFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC9F2F6)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: _teal, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Penarikan akan diproses maksimal 1x24 jam ke rekening yang terdaftar.',
              style: TextStyle(
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

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({super.key});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final _nameController = TextEditingController(text: 'Kantin Kampus Sejahtera');
  final _emailController = TextEditingController(text: 'tenant@kampus.ac.id');
  final _phoneController = TextEditingController(text: '081234567890');
  final _descriptionController = TextEditingController(
    text:
        'Kantin kampus dengan menu makanan rumahan, minuman segar, dan layanan cepat untuk mahasiswa.',
  );
  final _bankController = TextEditingController(text: 'BCA');
  final _accountNumberController = TextEditingController(text: '1234567890');
  final _accountOwnerController = TextEditingController(
    text: 'Kantin Kampus Sejahtera',
  );

  String _category = 'Makanan';
  String _location = 'Kantin Kampus';
  TimeOfDay _openTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 20, minute: 0);
  bool _openToday = true;
  bool _visibleToCustomer = true;
  bool _acceptOrders = true;
  bool _photoChanged = false;
  bool _submitted = false;

  late final _InitialBusinessProfile _initial;

  bool get _hasChanges {
    return _nameController.text != _initial.name ||
        _emailController.text != _initial.email ||
        _phoneController.text != _initial.phone ||
        _descriptionController.text != _initial.description ||
        _bankController.text != _initial.bank ||
        _accountNumberController.text != _initial.accountNumber ||
        _accountOwnerController.text != _initial.accountOwner ||
        _category != _initial.category ||
        _location != _initial.location ||
        _openTime != _initial.openTime ||
        _closeTime != _initial.closeTime ||
        _openToday != _initial.openToday ||
        _visibleToCustomer != _initial.visibleToCustomer ||
        _acceptOrders != _initial.acceptOrders ||
        _photoChanged;
  }

  bool get _isPhoneValid {
    final phone = _phoneController.text.trim();
    return phone.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  bool get _isValid {
    return _nameController.text.trim().isNotEmpty && _isPhoneValid;
  }

  @override
  void initState() {
    super.initState();
    _initial = _InitialBusinessProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      description: _descriptionController.text,
      bank: _bankController.text,
      accountNumber: _accountNumberController.text,
      accountOwner: _accountOwnerController.text,
      category: _category,
      location: _location,
      openTime: _openTime,
      closeTime: _closeTime,
      openToday: _openToday,
      visibleToCustomer: _visibleToCustomer,
      acceptOrders: _acceptOrders,
    );

    for (final controller in [
      _nameController,
      _emailController,
      _phoneController,
      _descriptionController,
      _bankController,
      _accountNumberController,
      _accountOwnerController,
    ]) {
      controller.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _bankController.dispose();
    _accountNumberController.dispose();
    _accountOwnerController.dispose();
    super.dispose();
  }

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
          'Profil Usaha',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 126),
          children: [
            _BusinessIdentityCard(
              name: _nameController.text.trim().isEmpty
                  ? 'Nama Usaha'
                  : _nameController.text.trim(),
              category: _category,
              onChangePhoto: () => setState(() => _photoChanged = true),
              photoChanged: _photoChanged,
            ),
            const SizedBox(height: 14),
            _ProfileCard(
              title: 'Informasi Dasar',
              icon: Icons.storefront_outlined,
              child: Column(
                children: [
                  _ProfileTextField(
                    controller: _nameController,
                    label: 'Nama Usaha',
                    hint: 'Masukkan nama usaha',
                    icon: Icons.badge_outlined,
                    errorText: _submitted &&
                            _nameController.text.trim().isEmpty
                        ? 'Nama usaha tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _ProfileTextField(
                    controller: _emailController,
                    label: 'Email Bisnis',
                    hint: 'Email bisnis',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _ProfileTextField(
                    controller: _phoneController,
                    label: 'Nomor Telepon',
                    hint: 'Nomor telepon aktif',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    errorText: _submitted && !_isPhoneValid
                        ? 'Nomor telepon harus angka'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileCard(
              title: 'Kategori Usaha',
              icon: Icons.category_outlined,
              child: _BusinessCategoryToggle(
                value: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
            ),
            const SizedBox(height: 14),
            _ProfileCard(
              title: 'Lokasi Usaha',
              icon: Icons.location_on_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _location,
                    decoration: _inputDecoration(
                      label: 'Lokasi Usaha',
                      hint: 'Pilih lokasi usaha',
                      icon: Icons.place_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Kantin Kampus',
                        child: Text('Kantin Kampus'),
                      ),
                      DropdownMenuItem(
                        value: 'Kantin Pesantren',
                        child: Text('Kantin Pesantren'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => _location = value);
                    },
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Lokasi tidak dapat diubah setelah disimpan.',
                    style: TextStyle(
                      color: Color(0xFF8A98A5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileCard(
              title: 'Jam Operasional',
              icon: Icons.schedule_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerField(
                          label: 'Jam Buka',
                          value: _formatTime(_openTime),
                          onTap: () => _pickTime(isOpening: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TimePickerField(
                          label: 'Jam Tutup',
                          value: _formatTime(_closeTime),
                          onTap: () => _pickTime(isOpening: false),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 26, color: Color(0xFFE9EEF2)),
                  _ProfileSwitch(
                    title: 'Buka Hari Ini',
                    subtitle: _openToday
                        ? 'Usaha aktif menerima kunjungan hari ini'
                        : 'Tutup sementara',
                    value: _openToday,
                    onChanged: (value) => setState(() => _openToday = value),
                  ),
                  if (!_openToday) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Tutup sementara',
                        style: TextStyle(
                          color: Color(0xFF617484),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileCard(
              title: 'Deskripsi Usaha',
              icon: Icons.notes_outlined,
              child: _ProfileTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
                hint:
                    'Ceritakan tentang usaha Anda, menu andalan, atau keunggulan usaha',
                icon: Icons.description_outlined,
                minLines: 4,
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 14),
            _ProfileCard(
              title: 'Pengaturan Tambahan',
              icon: Icons.tune_outlined,
              child: Column(
                children: [
                  _ProfileSwitch(
                    title: 'Tampilkan usaha ke pelanggan',
                    subtitle:
                        'Jika OFF, usaha tidak muncul di aplikasi pembeli',
                    value: _visibleToCustomer,
                    onChanged: (value) =>
                        setState(() => _visibleToCustomer = value),
                  ),
                  const Divider(height: 24, color: Color(0xFFE9EEF2)),
                  _ProfileSwitch(
                    title: 'Terima pesanan',
                    subtitle: 'Jika OFF, usaha tidak bisa menerima order',
                    value: _acceptOrders,
                    onChanged: (value) =>
                        setState(() => _acceptOrders = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileCard(
              title: 'Informasi Rekening',
              icon: Icons.account_balance_outlined,
              child: Column(
                children: [
                  _ProfileTextField(
                    controller: _bankController,
                    label: 'Nama Bank',
                    hint: 'Contoh: BCA',
                    icon: Icons.account_balance_outlined,
                  ),
                  const SizedBox(height: 12),
                  _ProfileTextField(
                    controller: _accountNumberController,
                    label: 'Nomor Rekening',
                    hint: 'Nomor rekening',
                    icon: Icons.credit_card_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _ProfileTextField(
                    controller: _accountOwnerController,
                    label: 'Nama Pemilik Rekening',
                    hint: 'Nama sesuai buku rekening',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Ubah Data Rekening'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _teal,
                        side: const BorderSide(color: _teal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Data rekening digunakan untuk penarikan saldo.',
                    style: TextStyle(
                      color: Color(0xFF8A98A5),
                      fontSize: 11,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
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
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF617484),
                      side: const BorderSide(color: Color(0xFFD8E1E7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _hasChanges ? _saveProfile : null,
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: const Text('Simpan Perubahan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _teal,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE4EAEE),
                      disabledForegroundColor: const Color(0xFF9AA7B2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refresh() {
    setState(() {});
  }

  Future<void> _pickTime({required bool isOpening}) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: isOpening ? _openTime : _closeTime,
    );
    if (selected == null) {
      return;
    }
    setState(() {
      if (isOpening) {
        _openTime = selected;
      } else {
        _closeTime = selected;
      }
    });
  }

  void _saveProfile() {
    setState(() => _submitted = true);

    if (!_isValid) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil usaha berhasil diperbarui'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}

class _InitialBusinessProfile {
  final String name;
  final String email;
  final String phone;
  final String description;
  final String bank;
  final String accountNumber;
  final String accountOwner;
  final String category;
  final String location;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final bool openToday;
  final bool visibleToCustomer;
  final bool acceptOrders;

  const _InitialBusinessProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.bank,
    required this.accountNumber,
    required this.accountOwner,
    required this.category,
    required this.location,
    required this.openTime,
    required this.closeTime,
    required this.openToday,
    required this.visibleToCustomer,
    required this.acceptOrders,
  });
}

class _BusinessIdentityCard extends StatelessWidget {
  final String name;
  final String category;
  final bool photoChanged;
  final VoidCallback onChangePhoto;

  const _BusinessIdentityCard({
    required this.name,
    required this.category,
    required this.photoChanged,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F7FA),
              shape: BoxShape.circle,
              border: Border.all(color: _teal.withValues(alpha: 0.28)),
            ),
            child: Icon(
              photoChanged
                  ? Icons.storefront_rounded
                  : Icons.storefront_outlined,
              color: _teal,
              size: 42,
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onChangePhoto,
            icon: const Icon(Icons.photo_camera_outlined, size: 17),
            label: const Text('Ubah Foto'),
            style: TextButton.styleFrom(
              foregroundColor: _teal,
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gunakan foto yang jelas agar menarik pelanggan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8A98A5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category,
            style: TextStyle(
              color: Color(0xFF617484),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessCategoryToggle extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _BusinessCategoryToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CategoryButton(
            label: 'Makanan',
            icon: Icons.rice_bowl_outlined,
            selected: value == 'Makanan',
            onTap: () => onChanged('Makanan'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CategoryButton(
            label: 'Minuman',
            icon: Icons.local_drink_outlined,
            selected: value == 'Minuman',
            onTap: () => onChanged('Minuman'),
          ),
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE5F7FA) : const Color(0xFFF8FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _teal : const Color(0xFFE1E8ED),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? _teal : const Color(0xFF617484),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? _teal : const Color(0xFF617484),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _ProfileCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(icon, color: _teal, size: 19),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? errorText;
  final int minLines;
  final int maxLines;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.errorText,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
        errorText: errorText,
      ),
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecoration(
          label: label,
          hint: 'Pilih jam',
          icon: Icons.access_time_outlined,
        ),
        child: Text(
          value,
          style: const TextStyle(
            color: _text,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ProfileSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF617484),
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: _teal,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCDD5DB),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required String hint,
  required IconData icon,
  String? errorText,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    errorText: errorText,
    prefixIcon: Icon(icon, color: const Color(0xFF8A98A5), size: 20),
    hintStyle: const TextStyle(
      color: Color(0xFFA7B2BA),
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    labelStyle: const TextStyle(
      color: Color(0xFF617484),
      fontWeight: FontWeight.w700,
    ),
    filled: true,
    fillColor: const Color(0xFFF8FAFB),
    border: _outlineBorder(const Color(0xFFE1E8ED)),
    enabledBorder: _outlineBorder(const Color(0xFFE1E8ED)),
    focusedBorder: _outlineBorder(_teal),
    errorBorder: _outlineBorder(const Color(0xFFE53935)),
    focusedErrorBorder: _outlineBorder(const Color(0xFFE53935)),
  );
}

OutlineInputBorder _outlineBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );
}

String _formatCurrency(int value) {
  return 'Rp ${value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      )}';
}
