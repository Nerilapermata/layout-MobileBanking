import 'package:flutter/material.dart';
import '../models/mutasi.dart'; // Pastikan import model Mutasi kamu

class TransferPage extends StatefulWidget {
  final int saldo;
  final Function(int) onTransfer;
  final Function(Mutasi) onAddMutasi; // Tambahan

  const TransferPage({
    super.key,
    required this.saldo,
    required this.onTransfer,
    required this.onAddMutasi, // Tambahan
  });

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final rekeningController = TextEditingController();
  final nominalController = TextEditingController();

  @override
  void dispose() {
    rekeningController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    if (_formKey.currentState!.validate()) {
      final nominal = int.parse(nominalController.text);

      if (nominal > widget.saldo) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Saldo tidak cukup")),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Konfirmasi Transfer"),
          content: Text("Transfer ke rekening ${rekeningController.text} sebesar Rp $nominal?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onTransfer(nominal);

                // ✅ Tambah mutasi di sini
                widget.onAddMutasi(Mutasi(
                jenis: 'Transfer',
                nominal: -nominal,
                tanggal: DateTime.now(),
              ));

                _showSuccessDialog(nominal);
              },
              child: const Text("Ya"),
            ),
          ],
        ),
      );
    }
  }

  void _showSuccessDialog(int nominal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Transfer Berhasil"),
        content: Text(
          "Anda telah mentransfer Rp $nominal ke rekening ${rekeningController.text}.",
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transfer"),
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
              // Keterangan saldo di tengah
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

              // Kolom rekening
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: rekeningController,
                  decoration: InputDecoration(
                    labelText: "Rekening Tujuan",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value!.isEmpty ? "Masukkan nomor rekening" : null,
                ),
              ),

              // Kolom nominal
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: TextFormField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Nominal Transfer",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) => value!.isEmpty ? "Masukkan nominal" : null,
                ),
              ),

              // Tombol di tengah
              Center(
                child: ElevatedButton(
                  onPressed: _handleTransfer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 36, 155),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Lanjutkan", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
