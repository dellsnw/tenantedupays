import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> data = [
    {
      "image": "assets/images/slide1.jpg",
      "title": "Kelola Tenant Kantin dengan Mudah",
      "desc": "Daftarkan usaha makanan dan minuman kamu dengan mudah."
    },
    {
      "image": "assets/images/slide2.jpg",
      "title": "Kelola Pesanan Lebih Praktis",
      "desc": "Pantau pesanan masuk dari mahasiswa secara sederhana dari satu aplikasi."
    },
    {
      "image": "assets/images/slide3.jpg",
      "title": "Atur Penjualan Lebih Rapi",
      "desc": "Kelola menu, saldo, dan laporan penjualan agar usaha berjalan teratur."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage())),
            child: Row(
              children: [
                Text("Lewati", style: TextStyle(color: Colors.grey)),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// SLIDE
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: data.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          data[index]['image']!,
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 40),
                        Text(
                          data[index]['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          data[index]['desc']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(data.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: 5),
                  height: 6,
                  width: currentIndex == index ? 22 : 6,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xFF00BCC9)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),

            SizedBox(height: 40),

            /// BUTTON AREA
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // TOMBOL UTAMA (Selanjutnya / Masuk)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentIndex < data.length - 1) {
                          // Jika belum di slide terakhir, geser ke slide berikutnya
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        } else {
                          // Jika sudah di slide terakhir (slide 3), pindah ke Login
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BCC9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        currentIndex < data.length - 1 ? "Selanjutnya" : "Masuk",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // TOMBOL DAFTAR (Hanya muncul di slide terakhir)
                  if (currentIndex == data.length - 1) ...[
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFF00BCC9)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Daftar Akun Baru",
                          style: TextStyle(
                              color: const Color(0xFF00BCC9),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Memberikan jarak kosong agar posisi tombol tetap stabil
                    SizedBox(height: 62),
                  ],
                ],
              ),
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
