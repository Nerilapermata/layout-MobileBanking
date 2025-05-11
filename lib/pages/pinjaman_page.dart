import 'package:flutter/material.dart';
import '../models/mutasi.dart'; // Pastikan file mutasi.dart diimport dengan benar

class PinjamanPage extends StatefulWidget {
  final int saldo;
  final Function(int) onPinjam;
  final Function(int) onBayar;
  final Function(Mutasi) onAddMutasi; // ✅ Tambahkan parameter mutasi

  const PinjamanPage({
    super.key,
    required this.saldo,
    required this.onPinjam,
    required this.onBayar,
    required this.onAddMutasi,
  });

  @override
  State<PinjamanPage> createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  List<Map<String, dynamic>> pinjamanAktif = [];
  String jenis = '';
  int jumlah = 0;
  String durasi = '';
  bool cicilanAktif = false;

  final _formKey = GlobalKey<FormState>();

  void showConfirmationAjukan() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pinjaman'),
        content: const Text('Apakah Anda yakin ingin mengajukan pinjaman ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                pinjamanAktif.add({
                  'jenis': jenis,
                  'jumlah': jumlah,
                  'durasi': durasi,
                  'cicilan': cicilanAktif,
                });
              });
              widget.onPinjam(jumlah);

              // ✅ Tambahkan mutasi pinjaman masuk (pemasukan)
              widget.onAddMutasi(Mutasi(
                jenis: 'Pinjaman',
                nominal: jumlah,
                tanggal: DateTime.now(),
              ));

              Navigator.of(ctx).pop();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Berhasil'),
                  content: const Text('Pinjaman telah disetujui!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }

  void bayarPinjaman(int index) {
    int jumlahBayar = pinjamanAktif[index]['jumlah'];
    widget.onBayar(jumlahBayar);

    // ✅ Tambahkan mutasi pembayaran pinjaman (pengeluaran)
    widget.onAddMutasi(Mutasi(
      jenis: 'Bayar Pinjaman',
      nominal: -jumlahBayar,
      tanggal: DateTime.now(),
    ));

    setState(() {
      pinjamanAktif.removeAt(index);
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil'),
        content: const Text('Pinjaman telah dibayar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinjaman', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 36, 155),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 236, 255),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Saldo Anda: Rp. ${widget.saldo}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (pinjamanAktif.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pinjaman Aktif", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...List.generate(pinjamanAktif.length, (index) {
                    final pinjaman = pinjamanAktif[index];
                    return Card(
                      child: ListTile(
                        title: Text("${pinjaman['jenis']} - Rp. ${pinjaman['jumlah']}"),
                        subtitle: Text("Durasi: ${pinjaman['durasi']}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => bayarPinjaman(index),
                          child: const Text('Bayar', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            const Text("Ajukan Pinjaman Baru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Jenis Pinjaman'),
                    onChanged: (val) => jenis = val,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Jumlah Pinjaman'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => jumlah = int.tryParse(val) ?? 0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Lama Pinjaman (durasi)'),
                    onChanged: (val) => durasi = val,
                  ),
                  SwitchListTile(
                    title: const Text('Aktifkan Cicilan'),
                    value: cicilanAktif,
                    onChanged: (val) => setState(() => cicilanAktif = val),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showConfirmationAjukan();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 36, 155),
                    ),
                    child: const Text('Ajukan', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
