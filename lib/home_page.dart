import 'package:flutter/material.dart';
import 'saldo_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                        color: const Color(0xFF00BCC9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.account_balance_wallet, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Text("Beranda", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications_none),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BusinessProfilePage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: 20),

              /// GREETING
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Halo, Tenant! 👋", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("24 Mei 2024", style: TextStyle(color: Colors.blue)),
                  )
                ],
              ),

              SizedBox(height: 15),

              /// CARD PENDAPATAN
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [const Color(0xFF00BCC9), const Color(0xFF00BCC9)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TOTAL PENDAPATAN (HARI INI)", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 10),
                    Text("Rp 850.000",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("+12.5% dari kemarin", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),

              SizedBox(height: 15),

              /// STAT BOX
              Row(
                children: [
                  statCard(Icons.inventory, "42", "Produk Terjual"),
                  SizedBox(width: 10),
                  statCard(Icons.shopping_bag, "5", "Pesanan Baru"),
                ],
              ),

              SizedBox(height: 20),

              /// AKTIVITAS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Aktivitas Hari Ini", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Lihat Semua >", style: TextStyle(color: const Color(0xFF00BCC9))),
                ],
              ),

              SizedBox(height: 10),

              activityItem("Budi Santoso", "14:20 • Nasi Ayam Geprek", "Rp 15.000"),
              activityItem("Siti Aminah", "13:45 • Es Teh Manis (2x)", "Rp 10.000"),
              activityItem("Andi Wijaya", "13:10 • Mie Goreng Spesial", "Rp 18.000"),

              SizedBox(height: 20),

              /// MENU TERLARIS
              Text("Menu Terlaris", style: TextStyle(fontWeight: FontWeight.bold)),

              SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                      child: Image.asset(
                        "assets/images/slide1.jpg",
                        width: 100,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nasi Ayam Geprek", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Terjual 128 porsi minggu ini", style: TextStyle(fontSize: 12)),
                            SizedBox(height: 5),
                            Text("Rp 15.000", style: TextStyle(color: const Color(0xFF00BCC9))),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 20),

              /// TIPS
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text("Berikan diskon 10% untuk mahasiswa baru untuk meningkatkan transaksi!"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// STAT CARD
  Widget statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF00BCC9)),
            SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  /// ACTIVITY ITEM
  Widget activityItem(String name, String detail, String price) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(detail, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}