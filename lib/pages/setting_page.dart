import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'profile_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> _showUpdateDialog({
    required BuildContext context,
    required String title,
    required String label,
    required String key,
  }) async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: key == 'pin', // PIN disembunyikan
          keyboardType: key == 'pin' ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(key, newValue);

                Navigator.pop(context); // Tutup dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title berhasil diperbarui!')),
                );
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 36, 155),
      ),
      body: ListView(
        children: [
          // Profil
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil"),
            subtitle: const Text("Lihat atau edit profil Anda"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(),

          // Ubah Password
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Ubah Password"),
            subtitle: const Text("Perbarui password Anda"),
            onTap: () {
              _showUpdateDialog(
                context: context,
                title: "Ubah Password",
                label: "Password Baru",
                key: "password",
              );
            },
          ),
          const Divider(),

          // Ubah PIN
          ListTile(
            leading: const Icon(Icons.pin),
            title: const Text("Ubah PIN"),
            subtitle: const Text("Perbarui PIN untuk transaksi"),
            onTap: () {
              _showUpdateDialog(
                context: context,
                title: "Ubah PIN",
                label: "PIN Baru",
                key: "pin",
              );
            },
          ),
          const Divider(),

          // Pilih Bahasa
          const ListTile(
            leading: Icon(Icons.language),
            title: Text("Bahasa"),
            subtitle: Text("Pilih bahasa aplikasi"),
          ),
          const Divider(),

          // Keluar
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Keluar"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
