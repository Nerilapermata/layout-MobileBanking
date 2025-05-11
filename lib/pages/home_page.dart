import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/mutasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/home_card.dart';
import 'cek_saldo_page.dart';
import 'transfer_page.dart';
import 'deposito_page.dart';
import 'pembayaran_page.dart';
import 'pinjaman_page.dart'; // Import halaman pinjaman
import 'mutasi_page.dart';
import 'setting_page.dart';
import 'profile_page.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  final String username;
  final String password;

  const HomePage({super.key, required this.username, required this.password});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int saldo = 2500000;

  List<Mutasi> mutasiList = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn == null || !isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Koperasi Undiksha",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 36, 155),
        centerTitle: true,
        
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _logout, // ← Ubah jadi pakai SharedPreferences logout
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info Nasabah
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: const Color.fromARGB(255, 0, 36, 155)),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
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
                  Expanded(
                    child: Column(
                      children: [
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
                                widget.username,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
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
                                "Total Saldo Anda",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Rp. $saldo",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

            // Menu Grid
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color.fromARGB(255, 0, 36, 155)),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                children: [
                  // Cek Saldo
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CekSaldoPage(saldo: saldo),
                        ),
                      );
                    },
                    child: const HomeCard(
                      icon: Icons.account_balance_wallet,
                      label: "Cek Saldo",
                      iconColor: Color.fromARGB(255, 12, 69, 255),
                    ),
                  ),

                  // Transfer
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferPage(
                            saldo: saldo,
                            onTransfer: (int nominal) {
                              setState(() {
                                saldo -= nominal;
                              });
                            },
                            onAddMutasi: (mutasiBaru) {
                              setState(() {
                                mutasiList.add(mutasiBaru);
                              });
                            },

                          ),
                        ),
                      );
                    },
                    child: const HomeCard(
                      icon: Icons.send,
                      label: "Transfer",
                      iconColor: Color.fromARGB(255, 12, 69, 255),
                    ),
                  ),

                  // Deposito
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepositoPage(
                            saldo: saldo,
                            onDeposito: (int nominal) {
                              setState(() {
                                saldo += nominal;
                              });
                            },
                            onAddMutasi: (mutasiBaru) {
                              setState(() {
                                mutasiList.add(mutasiBaru);
                              });
                            },

                          ),
                        ),
                      );
                    },
                    child: const HomeCard(
                      icon: Icons.savings,
                      label: "Deposito",
                      iconColor: Color.fromARGB(255, 12, 69, 255),
                    ),
                  ),

                  // Pembayaran
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PembayaranPage(
                            saldo: saldo,
                            onPembayaran: (int nominal) {
                              setState(() {
                                saldo -= nominal;
                              });
                            },
                            onAddMutasi: (mutasiBaru) {
                              setState(() {
                                mutasiList.add(mutasiBaru);
                              });
                            },

                          ),
                        ),
                      );
                    },
                    child: const HomeCard(
                      icon: Icons.payment,
                      label: "Pembayaran",
                      iconColor: Color.fromARGB(255, 12, 69, 255),
                    ),
                  ),

                  // Pinjaman
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PinjamanPage(
                            saldo: saldo,
                            onPinjam: (int pinjam) {
                              setState(() {
                                saldo += pinjam;
                              });
                            },
                            onBayar: (int bayar) {
                              setState(() {
                                saldo -= bayar;
                              });
                            },
                            onAddMutasi: (mutasiBaru) {
                              setState(() {
                                mutasiList.add(mutasiBaru);
                              });
                            },

                          ),
                        ),
                      );
                    },
                    child: const HomeCard(
                      icon: Icons.attach_money,
                      label: "Pinjaman",
                      iconColor: Color.fromARGB(255, 12, 69, 255),
                    ),
                  ),

                  // Mutasi
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MutasiPage(
                            mutasiList: mutasiList,
                          ),
                        ),
                      );
                    },
                    child: const HomeCard(
                      icon: Icons.history,
                      label: "Mutasi",
                      iconColor: Color.fromARGB(255, 12, 69, 255),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bantuan
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5),
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


            // Menu Bawah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Setting Menu
                InkWell(
                  onTap: () {
                    // Navigasi ke halaman pengaturan
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingPage()),
                    );
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.settings, size: 40, color: Color.fromARGB(255, 12, 69, 255)),
                      Text("Setting")
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.qr_code, size: 40, color: Color.fromARGB(255, 12, 69, 255)),
                    Text("QR Code")
                  ],
                ),

                // Profile Menu
                InkWell(
                  onTap: () {
                    // Navigasi ke halaman profile
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.person, size: 40, color: Color.fromARGB(255, 12, 69, 255)),
                      Text("Profile")
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}