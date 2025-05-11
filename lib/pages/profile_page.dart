import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = 'nerila@student.undiksha.ac.id';
  String phone = '0878-1234-1024';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? email;
      phone = prefs.getString('phone') ?? phone;
    });
  }

  Future<void> _showEditDialog({
    required String title,
    required String currentValue,
    required String key,
  }) async {
    final controller = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah $title'),
        content: TextField(
          controller: controller,
          keyboardType: key == 'phone' ? TextInputType.phone : TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Masukkan $title baru',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString(key, newValue);
                setState(() {
                  if (key == 'email') {
                    email = newValue;
                  } else if (key == 'phone') {
                    phone = newValue;
                  }
                });
                Navigator.pop(context); // tutup dialog
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
        title: const Text('Profil Pengguna', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 36, 155),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Foto Profil Bulat
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'nerila.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Nerila Permata Aly',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Mahasiswa di Universitas Pendidikan Ganesha, Koperasi Undiksha',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Email dengan tombol edit
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(email),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(title: "Email", currentValue: email, key: 'email');
                  },
                ),
              ),

              // No telepon dengan tombol edit
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Nomor Telepon"),
                subtitle: Text(phone),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(title: "Nomor Telepon", currentValue: phone, key: 'phone');
                  },
                ),
              ),

              const Divider(),

              const ListTile(
                leading: Icon(Icons.location_on),
                title: Text("Alamat"),
                subtitle: Text("Buleleng, Bali"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
