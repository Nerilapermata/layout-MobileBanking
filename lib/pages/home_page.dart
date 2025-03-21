import 'package:flutter/material.dart';
import '../widgets/home_card.dart';

class HomePage extends StatelessWidget {
  final String username;
  final String password;
  const HomePage({super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Koperasi Undiksha",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 0, 36, 155),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Warna putih
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Kotak Nasabah & Saldo
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Color.fromARGB(255, 0, 36, 155)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'nerila.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Kotak Informasi Nasabah & Saldo
                    Expanded(
                      child: Column(
                        children: [
                          // Kotak Nasabah
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 207, 217, 241),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Nasabah",
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  username,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Kotak Saldo
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 207, 217, 241),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Saldo Anda",
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Rp. 1.200.000",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Grid Menu Utama
              Container(
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color.fromARGB(255, 0, 36, 155)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5),
                  ],
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                  children: const [
                    HomeCard(icon: Icons.account_balance_wallet, label: "Cek Saldo", iconColor: Color.fromARGB(255, 12, 69, 255)),
                    HomeCard(icon: Icons.send, label: "Transfer", iconColor: Color.fromARGB(255, 12, 69, 255)),
                    HomeCard(icon: Icons.savings, label: "Deposito", iconColor: Color.fromARGB(255, 12, 69, 255)),
                    HomeCard(icon: Icons.payment, label: "Pembayaran", iconColor: Color.fromARGB(255, 12, 69, 255)),
                    HomeCard(icon: Icons.attach_money, label: "Pinjaman", iconColor: Color.fromARGB(255, 12, 69, 255)),
                    HomeCard(icon: Icons.history, label: "Mutasi", iconColor: Color.fromARGB(255, 12, 69, 255)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bagian "Butuh Bantuan?"
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Butuh Bantuan?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone, color: Color.fromARGB(255, 12, 69, 255), size: 40),
                        SizedBox(width: 10),
                        Text(
                          "0878-1234-1024",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu Bawah (Settings, QR Code, Profile)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: const [
                      Icon(Icons.settings, size: 40, color: Color.fromARGB(255, 12, 69, 255)),
                      Text("Setting")
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(Icons.qr_code, size: 40, color: Color.fromARGB(255, 12, 69, 255)),
                      Text("QR Code")
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(Icons.person, size: 40, color: Color.fromARGB(255, 12, 69, 255)),
                      Text("Profile")
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
