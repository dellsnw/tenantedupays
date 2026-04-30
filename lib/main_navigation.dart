import 'package:flutter/material.dart';
import 'home_page.dart';
import 'laporan_page.dart';
import 'menu_management_page.dart';
import 'order_list_page.dart';
import 'saldo_page.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 2; // Default ke Home

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Membuat konten mengalir di bawah navbar
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 0: Pesanan
          OrderListPage(),
          // 1: Menu
          MenuManagementPage(),
          // 2: Home (Dashboard)
          HomePage(),
          // 3: Saldo
          SaldoPage(),
          // 4: Laporan
          LaporanPage(),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 65, // Ukuran FAB ditingkatkan agar menonjol
        width: 65,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF00BCC9),
          elevation: 2, // Shadow halus
          onPressed: () => setState(() => _currentIndex = 2),
          shape: const CircleBorder(), // Membuat FAB bulat sempurna
          child: const Icon(Icons.home_outlined, size: 35, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 70, // Tinggi navbar yang ideal
        color: Colors.white,
        shape: const CircularNotchedRectangle(), // Lengkungan halus di tengah
        notchMargin: 10, // Jarak lengkungan dari tombol bulat
        elevation: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SISI KIRI
            _buildNavItem(0, Icons.assignment_outlined, "Pesanan"),
            _buildNavItem(1, Icons.restaurant_menu, "Menu"),

            const SizedBox(width: 40), // Spacer untuk tempat tombol bulat di tengah

            // SISI KANAN
            _buildNavItem(3, Icons.account_balance_wallet_outlined, "Saldo"),
            _buildNavItem(4, Icons.bar_chart_outlined, "Laporan"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar ikon dan teks berdekatan
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? const Color(0xFF00BCC9) : const Color(0xFF455A64),
            ),
            const SizedBox(height: 2), // Jarak sempit agar rapi
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? const Color(0xFF00BCC9) : const Color(0xFF455A64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
