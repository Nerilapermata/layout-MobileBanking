import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mutasi.dart'; // Pastikan path-nya sesuai

class DepositoPage extends StatefulWidget {
  final int saldo;
  final Function(int) onDeposito;
  final Function(Mutasi) onAddMutasi;

  const DepositoPage({
    super.key,
    required this.saldo,
    required this.onDeposito,
    required this.onAddMutasi,
  });

  @override
  State<DepositoPage> createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  final _formKey = GlobalKey<FormState>();
  final jumlahController = TextEditingController();
  final tokenController = TextEditingController();

  @override
  void dispose() {
    jumlahController.dispose();
    tokenController.dispose();
    super.dispose();
  }

  Future<String> _getSavedPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin') ?? '123456';
  }

  Future<void> _setNewPin(String newPin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', newPin);
  }

  void _handleDeposito() async {
    if (_formKey.currentState!.validate()) {
      final jumlah = int.parse(jumlahController.text);
      final token = tokenController.text;
      final savedPin = await _getSavedPin();

      if (token != savedPin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token salah! Gunakan yang benar")),
        );
        return;
      }

      widget.onDeposito(jumlah);
      widget.onAddMutasi(Mutasi(
        jenis: 'Deposito',
        nominal: jumlah,
        tanggal: DateTime.now(),
      ));

      _showSuccessDialog(jumlah);
    }
  }

  void _showSuccessDialog(int jumlah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deposito Berhasil"),
        content: Text("Berhasil menambahkan Rp $jumlah ke saldo."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showForgotPinDialog() {
    final TextEditingController newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ganti PIN"),
        content: TextField(
          controller: newPinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "PIN Baru",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              String newPin = newPinController.text.trim();
              if (newPin.isEmpty || newPin.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("PIN harus minimal 4 angka!")),
                );
                return;
              }

              await _setNewPin(newPin);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("PIN berhasil diubah!")),
              );

              tokenController.text = newPin;
              _handleDeposito();
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
        title: const Text("Deposito"),
        backgroundColor: const Color.fromARGB(255, 0, 36, 155),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 228, 238, 255),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Text(
                    "Saldo Anda: Rp ${widget.saldo}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Jumlah Deposito",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value!.isEmpty ? "Masukkan jumlah deposito" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tokenController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Token (PIN)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value!.isEmpty ? "Masukkan token" : null,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _handleDeposito,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 36, 155),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Lanjutkan", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: _showForgotPinDialog,
                  child: const Text("Lupa PIN?", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
