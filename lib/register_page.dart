import 'package:flutter/material.dart';
import 'main_navigation.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Tenant Baru"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/bg.jpg",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 20),

            /// TITLE
            Center(
              child: Column(
                children: [
                  Text(
                    "Mulai Bisnis Anda",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00BCC9),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Isi formulir di bawah untuk bergabung dengan Edupays",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            /// NAMA USAHA
            Text("Nama Usaha"),
            SizedBox(height: 8),
            TextField(
              decoration: inputStyle("Contoh: Kedai Kopi Kampus", Icons.store),
            ),

            SizedBox(height: 16),

            /// EMAIL
            Text("Email Bisnis"),
            SizedBox(height: 8),
            TextField(
              decoration: inputStyle("nama@bisnis.com", Icons.email),
            ),

            SizedBox(height: 16),

            /// PASSWORD
            Text("Kata Sandi"),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: inputStyle("Min. 8 karakter", Icons.lock)
                  .copyWith(suffixIcon: Icon(Icons.visibility)),
            ),

            SizedBox(height: 16),

            /// TELEPON + KATEGORI
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nomor Telepon"),
                      SizedBox(height: 8),
                      TextField(
                        decoration:
                            inputStyle("0812xxxx", Icons.phone),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kategori"),
                      SizedBox(height: 8),
                      DropdownButtonFormField(
                        items: [
                          DropdownMenuItem(
                              child: Text("Makanan"), value: "Makanan"),
                          DropdownMenuItem(
                              child: Text("Minuman"), value: "Minuman"),
                        ],
                        onChanged: (value) {},
                        decoration: inputStyle("", Icons.fastfood),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            /// LOKASI
            Text("Lokasi"),
            SizedBox(height: 8),
            DropdownButtonFormField(
              items: [
                DropdownMenuItem(
                  child: Text("Tenant Kantin Telkom University"),
                  value: "Tel-U",
                ),
                DropdownMenuItem(
                  child: Text("Tenant Pesantren Al-Ihsan"),
                  value: "Pesantren",
                ),
              ],
              onChanged: (value) {},
              decoration: inputStyle("", Icons.location_on),
            ),

            SizedBox(height: 16),

            /// JAM OPERASIONAL
            Text("Jam Operasional"),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: inputStyle("08:00", Icons.access_time),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("s/d"),
                ),
                Expanded(
                  child: TextField(
                    decoration: inputStyle("20:00", Icons.access_time),
                  ),
                ),
              ],
            ),

            SizedBox(height: 25),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainNavigation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCC9),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Daftar Sekarang"),
              ),
            ),

            SizedBox(height: 15),

            /// LOGIN LINK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// STYLE INPUT
  InputDecoration inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}