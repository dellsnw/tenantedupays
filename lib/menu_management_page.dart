import 'package:flutter/material.dart';

const Color _teal = Color(0xFF00B8C8);
const Color _bg = Color(0xFFF5F8FA);
const Color _text = Color(0xFF172B3A);
const double _bottomNavClearance = 96;

class MenuItemData {
  final String name;
  final String category;
  final String description;
  final double price;
  final int stock;
  final IconData icon;
  final Color color;
  bool isAvailable;

  MenuItemData({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.icon,
    required this.color,
    required this.isAvailable,
  });
}

class MenuManagementPage extends StatefulWidget {
  const MenuManagementPage({super.key});

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  String _selectedFilter = 'Semua';

  final List<MenuItemData> _menus = [
    MenuItemData(
      name: 'Ayam Geprek Sambal Matah',
      category: 'Makanan',
      description: 'Nasi, ayam geprek, sambal matah, lalapan',
      price: 25000,
      stock: 18,
      icon: Icons.rice_bowl_outlined,
      color: const Color(0xFFFFB74D),
      isAvailable: true,
    ),
    MenuItemData(
      name: 'Es Teh Manis Jumbo',
      category: 'Minuman',
      description: 'Teh manis dingin ukuran jumbo',
      price: 5000,
      stock: 0,
      icon: Icons.local_drink_outlined,
      color: const Color(0xFF4FC3F7),
      isAvailable: false,
    ),
    MenuItemData(
      name: 'Mie Ayam Bakso',
      category: 'Makanan',
      description: 'Mie ayam dengan bakso sapi dan pangsit',
      price: 22000,
      stock: 12,
      icon: Icons.ramen_dining_outlined,
      color: const Color(0xFF81C784),
      isAvailable: true,
    ),
    MenuItemData(
      name: 'Kopi Susu Kampus',
      category: 'Minuman',
      description: 'Kopi susu dingin gula aren',
      price: 12000,
      stock: 0,
      icon: Icons.coffee_outlined,
      color: const Color(0xFFA1887F),
      isAvailable: false,
    ),
  ];

  List<MenuItemData> get _filteredMenus {
    if (_selectedFilter == 'Semua') {
      return _menus;
    }
    return _menus.where((menu) => menu.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMenuEmpty = _menus.isEmpty;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 20,
        title: const Text(
          'Manajemen Menu',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, size: 22),
            color: const Color(0xFF617484),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: isMenuEmpty
            ? _EmptyMenuState(onAdd: _openAddMenuPage)
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                    child: Row(
                      children: [
                        _FilterChipButton(
                          label: 'Semua',
                          selected: _selectedFilter == 'Semua',
                          onTap: () => setState(() => _selectedFilter = 'Semua'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChipButton(
                          label: 'Makanan',
                          selected: _selectedFilter == 'Makanan',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Makanan'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChipButton(
                          label: 'Minuman',
                          selected: _selectedFilter == 'Minuman',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Minuman'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _filteredMenus.isEmpty
                        ? const _SmallEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              16,
                              16,
                              168,
                            ),
                            itemCount: _filteredMenus.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final menu = _filteredMenus[index];
                              return _MenuCard(
                                menu: menu,
                                onToggle: (value) => _toggleAvailability(
                                  menu,
                                  value: value,
                                ),
                                onEdit: () => _openEditMenuPage(menu),
                                onDelete: () => _confirmDeleteMenu(menu),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: _bottomNavClearance),
        child: FloatingActionButton.extended(
          heroTag: 'add-menu-fab',
          onPressed: _openAddMenuPage,
          backgroundColor: _teal,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Tambah Menu',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }

  void _toggleAvailability(MenuItemData menu, {required bool value}) {
    setState(() {
      menu.isAvailable = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value ? 'Menu tersedia kembali' : 'Menu dinonaktifkan sementara',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openAddMenuPage() async {
    final addedMenu = await Navigator.push<MenuItemData>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddMenuPage(),
      ),
    );

    if (addedMenu == null || !mounted) {
      return;
    }

    setState(() {
      _menus.insert(0, addedMenu);
      _selectedFilter = 'Semua';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menu berhasil ditambahkan'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openEditMenuPage(MenuItemData menu) async {
    final editedMenu = await Navigator.push<MenuItemData>(
      context,
      MaterialPageRoute(
        builder: (_) => AddMenuPage(initialMenu: menu),
      ),
    );

    if (editedMenu == null || !mounted) {
      return;
    }

    final index = _menus.indexOf(menu);
    if (index == -1) {
      return;
    }

    setState(() {
      _menus[index] = editedMenu;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menu berhasil diperbarui'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDeleteMenu(MenuItemData menu) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.58),
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
        contentPadding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Color(0xFFE53935)),
            SizedBox(width: 10),
            Text(
              'Hapus Menu?',
              style: TextStyle(
                color: _text,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          '${menu.name} akan dihapus dari daftar menu. Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(
            color: Color(0xFF617484),
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: Color(0xFF617484),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_outline_rounded, size: 17),
            label: const Text('Hapus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _menus.remove(menu);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menu.name} berhasil dihapus'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItemData menu;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MenuCard({
    required this.menu,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final unavailable = !menu.isAvailable;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unavailable ? const Color(0xFFE5E9ED) : Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173241).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MenuImage(menu: menu),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        menu.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: unavailable
                              ? const Color(0xFF6B7680)
                              : _text,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: menu.isAvailable,
                      onChanged: onToggle,
                      activeThumbColor: Colors.white,
                      activeTrackColor: _teal,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFCDD5DB),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  menu.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      _formatCurrency(menu.price),
                      style: const TextStyle(
                        color: _teal,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    _IconAction(
                      icon: Icons.edit_outlined,
                      color: _teal,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 6),
                    _IconAction(
                      icon: Icons.delete_outline_rounded,
                      color: const Color(0xFFE53935),
                      onTap: onDelete,
                    ),
                  ],
                ),
                if (unavailable) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
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
                          'Tidak Tersedia',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Stok habis',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF8A98A5),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  final MenuItemData menu;

  const _MenuImage({required this.menu});

  @override
  Widget build(BuildContext context) {
    final unavailable = !menu.isAvailable;

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: unavailable ? 0.45 : 1,
          duration: const Duration(milliseconds: 180),
          child: Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: menu.color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(menu.icon, color: menu.color, size: 36),
          ),
        ),
        if (unavailable)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        if (unavailable)
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECEFF1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Habis',
                style: TextStyle(
                  color: Color(0xFF617484),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyMenuState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyMenuState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 72),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF173241).withValues(alpha: 0.07),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F7FA),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    color: _teal,
                    size: 48,
                  ),
                  Positioned(
                    right: 24,
                    bottom: 28,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: _teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Belum Ada Menu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _text,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mulai tambahkan menu makanan atau minuman untuk ditampilkan ke pelanggan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF617484),
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('+ Tambah Menu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

class _SmallEmptyState extends StatelessWidget {
  const _SmallEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.no_food_outlined,
                color: Color(0xFFB5C1C9),
                size: 34,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tidak ada menu dalam kategori ini',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF617484),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
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
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _teal : const Color(0xFFF0F4F6),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF617484),
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

String _formatCurrency(double value) {
  return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      )}';
}

class AddMenuPage extends StatefulWidget {
  final MenuItemData? initialMenu;

  const AddMenuPage({super.key, this.initialMenu});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = 'Makanan';
  int _stock = 1;
  bool _isFeatured = false;
  bool _isAvailable = true;
  bool _hasPhoto = false;
  bool _submitted = false;
  bool _nameTouched = false;
  bool _priceTouched = false;
  bool _formattingPrice = false;

  bool get _isEditMode => widget.initialMenu != null;

  int get _priceValue => int.tryParse(_priceController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      )) ?? 0;

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty && _priceValue > 0;

  @override
  void initState() {
    super.initState();
    final initialMenu = widget.initialMenu;
    if (initialMenu != null) {
      _nameController.text = initialMenu.name;
      _priceController.text = _formatCurrency(initialMenu.price);
      _descriptionController.text =
          initialMenu.description == 'Belum ada deskripsi menu'
              ? ''
              : initialMenu.description;
      _category = initialMenu.category;
      _stock = initialMenu.stock;
      _isAvailable = initialMenu.stock > 0 && initialMenu.isAvailable;
      _hasPhoto = true;
    }
    _nameController.addListener(_refreshForm);
    _priceController.addListener(_formatPriceInput);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
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
        title: Text(
          _isEditMode ? 'Edit Menu' : 'Tambah Menu',
          style: TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            color: const Color(0xFF617484),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            children: [
              _UploadPhotoCard(
                hasPhoto: _hasPhoto,
                category: _category,
                onTap: () => setState(() => _hasPhoto = true),
              ),
              const SizedBox(height: 14),
              _FormCard(
                title: 'Informasi Utama Menu',
                icon: Icons.restaurant_menu_rounded,
                child: Column(
                  children: [
                    _AppTextField(
                      controller: _nameController,
                      label: 'Nama Menu',
                      hint: 'Contoh: Ayam Geprek Sambal Matah',
                      icon: Icons.fastfood_outlined,
                      errorText: (_submitted || _nameTouched) &&
                              _nameController.text.trim().isEmpty
                          ? 'Nama menu wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _CategorySelector(
                      value: _category,
                      onChanged: (value) => setState(() => _category = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _FormCard(
                title: 'Harga dan Stok',
                icon: Icons.inventory_2_outlined,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _AppTextField(
                        controller: _priceController,
                        label: 'Harga (Rp)',
                        hint: 'Rp 0',
                        icon: Icons.payments_outlined,
                        keyboardType: TextInputType.number,
                        errorText: (_submitted || _priceTouched) &&
                                _priceValue <= 0
                            ? 'Harga harus lebih dari 0'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StockStepper(
                        value: _stock,
                        onChanged: _setStock,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _FormCard(
                title: 'Deskripsi Menu',
                icon: Icons.notes_rounded,
                child: _AppTextField(
                  controller: _descriptionController,
                  label: 'Deskripsi',
                  hint: 'Jelaskan detail menu, bahan, atau tingkat kepedasan',
                  icon: Icons.description_outlined,
                  minLines: 4,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 14),
              _FormCard(
                title: 'Opsi Tambahan',
                icon: Icons.tune_rounded,
                child: Column(
                  children: [
                    _OptionSwitch(
                      title: 'Tampilkan sebagai menu unggulan',
                      subtitle: 'Menu tampil lebih menonjol di katalog',
                      value: _isFeatured,
                      onChanged: (value) => setState(() => _isFeatured = value),
                    ),
                    const Divider(height: 22, color: Color(0xFFE9EEF2)),
                    _OptionSwitch(
                      title: 'Aktifkan ketersediaan menu',
                      subtitle: _stock == 0
                          ? 'Stok 0 membuat menu tidak tampil ke pelanggan'
                          : 'Jika dimatikan, menu tidak tampil ke pelanggan',
                      value: _isAvailable,
                      onChanged: _stock == 0
                          ? null
                          : (value) => setState(() => _isAvailable = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const _TipsCard(),
            ],
          ),
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
                    onPressed: _isValid ? _saveMenu : null,
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: Text(
                      _isEditMode ? 'Simpan Perubahan' : 'Simpan Menu',
                    ),
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
                        fontSize: 14,
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

  void _refreshForm() {
    _nameTouched = true;
    setState(() {});
  }

  void _formatPriceInput() {
    _priceTouched = true;
    if (_formattingPrice) {
      return;
    }

    final digits = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final formatted = digits.isEmpty ? '' : _formatCurrency(double.parse(digits));

    if (_priceController.text == formatted) {
      setState(() {});
      return;
    }

    _formattingPrice = true;
    _priceController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _formattingPrice = false;
    setState(() {});
  }

  void _setStock(int value) {
    final safeValue = value < 0 ? 0 : value;
    setState(() {
      _stock = safeValue;
      if (_stock == 0) {
        _isAvailable = false;
      }
    });
  }

  void _saveMenu() {
    setState(() => _submitted = true);

    if (!_isValid) {
      return;
    }

    final menu = MenuItemData(
      name: _nameController.text.trim(),
      category: _category,
      description: _descriptionController.text.trim().isEmpty
          ? 'Belum ada deskripsi menu'
          : _descriptionController.text.trim(),
      price: _priceValue.toDouble(),
      stock: _stock,
      icon: _category == 'Makanan'
          ? widget.initialMenu?.icon ?? Icons.rice_bowl_outlined
          : widget.initialMenu?.icon ?? Icons.local_drink_outlined,
      color: _category == 'Makanan'
          ? const Color(0xFFFFB74D)
          : const Color(0xFF4FC3F7),
      isAvailable: _stock > 0 && _isAvailable,
    );

    Navigator.pop(context, menu);
  }
}

class _UploadPhotoCard extends StatelessWidget {
  final bool hasPhoto;
  final String category;
  final VoidCallback onTap;

  const _UploadPhotoCard({
    required this.hasPhoto,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      title: 'Upload Foto Produk',
      icon: Icons.add_photo_alternate_outlined,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 190,
          width: double.infinity,
          decoration: BoxDecoration(
            color: hasPhoto ? const Color(0xFFE5F7FA) : const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasPhoto ? _teal : const Color(0xFFB9C7D0),
              width: 1.4,
            ),
          ),
          child: CustomPaint(
            painter: hasPhoto ? null : _DashedBorderPainter(),
            child: Center(
              child: hasPhoto
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            category == 'Makanan'
                                ? Icons.rice_bowl_outlined
                                : Icons.local_drink_outlined,
                            color: _teal,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Ganti Foto',
                            style: TextStyle(
                              color: _teal,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          color: _teal,
                          size: 42,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Ketuk untuk unggah foto',
                          style: TextStyle(
                            color: _text,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Rasio 1:1 atau 16:9 disarankan (Max 2MB)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8A98A5),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _FormCard({
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
            color: const Color(0xFF173241).withValues(alpha: 0.07),
            blurRadius: 18,
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

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? errorText;
  final int minLines;
  final int maxLines;

  const _AppTextField({
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
      decoration: InputDecoration(
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
        border: _inputBorder(const Color(0xFFE1E8ED)),
        enabledBorder: _inputBorder(const Color(0xFFE1E8ED)),
        focusedBorder: _inputBorder(_teal),
        errorBorder: _inputBorder(const Color(0xFFE53935)),
        focusedErrorBorder: _inputBorder(const Color(0xFFE53935)),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CategorySelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SelectableButton(
            label: 'Makanan',
            icon: Icons.rice_bowl_outlined,
            selected: value == 'Makanan',
            onTap: () => onChanged('Makanan'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SelectableButton(
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

class _SelectableButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableButton({
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
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
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

class _StockStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _StockStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stok',
          style: TextStyle(
            color: Color(0xFF617484),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E8ED)),
          ),
          child: Row(
            children: [
              _StepperButton(
                icon: Icons.remove_rounded,
                onTap: () => onChanged(value - 1),
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add_rounded,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ),
        if (value == 0) ...[
          const SizedBox(height: 7),
          const Text(
            'Otomatis tidak tersedia',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFE5F7FA),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: _teal, size: 20),
      ),
    );
  }
}

class _OptionSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _OptionSwitch({
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

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAFBFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC9F2F6)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: _teal, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Pengelolaan',
                  style: TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Pastikan harga sudah termasuk biaya layanan jika ada. Anda bisa mengubah stok kapan saja.',
                  style: TextStyle(
                    color: Color(0xFF617484),
                    fontSize: 12,
                    height: 1.45,
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

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final paint = Paint()
      ..color = const Color(0xFFB9C7D0)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(14),
    );

    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final segment = metric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

OutlineInputBorder _inputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );
}
