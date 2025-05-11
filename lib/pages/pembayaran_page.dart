import 'package:flutter/material.dart';
import '../models/mutasi.dart';

class PembayaranPage extends StatefulWidget {
  final int saldo;
  final Function(int) onPembayaran;
  final Function(Mutasi) onAddMutasi; // ✅ Tambahkan parameter mutasi

  const PembayaranPage({
    Key? key,
    required this.saldo,
    required this.onPembayaran,
    required this.onAddMutasi, // ✅ Tambahkan ke konstruktor
  }) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  late int currentSaldo;
  final TextEditingController jenisController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  List<String> kategoriList = ['Tagihan Listrik', 'Pulsa', 'Top Up'];
  String? selectedKategori;

  @override
  void initState() {
    super.initState();
    currentSaldo = widget.saldo;
  }

  void tambahKategoriBaru() async {
    String? kategoriBaru = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController inputController = TextEditingController();
        return AlertDialog(
          title: const Text('Tambah Kategori Baru'),
          content: TextField(
            controller: inputController,
            decoration: const InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(inputController.text);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    if (kategoriBaru != null && kategoriBaru.trim().isNotEmpty) {
      setState(() {
        kategoriList.add(kategoriBaru.trim());
        selectedKategori = kategoriBaru.trim();
        jenisController.text = kategoriBaru.trim();
      });
    }
  }

  void lanjutkanPembayaran() {
    final int nominal = int.tryParse(nominalController.text) ?? 0;
    final String jenis = jenisController.text.trim();

    if (nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal tidak valid')),
      );
      return;
    }

    if (nominal > currentSaldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo tidak mencukupi')),
      );
      return;
    }

    // Konfirmasi pembayaran
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Pembayaran"),
        content: Text("Apakah Anda yakin ingin membayar Rp $nominal?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              prosesPembayaran(nominal, jenis); // ✅ Kirim jenis juga
            },
            child: const Text("Ya, Bayar"),
          ),
        ],
      ),
    );
  }

  void prosesPembayaran(int nominal, String jenis) {
    setState(() {
      currentSaldo -= nominal;
    });

    widget.onPembayaran(nominal);

    // ✅ Tambahkan mutasi pembayaran
    widget.onAddMutasi(Mutasi(
      jenis: "Pembayaran - $jenis",
      nominal: -nominal,
      tanggal: DateTime.now(),
    ));

    // Pop-up sukses
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pembayaran Berhasil"),
        content: Text("Pembayaran sebesar Rp $nominal telah dilakukan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    jenisController.clear();
    nomorController.clear();
    nominalController.clear();
    selectedKategori = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 36, 155),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Saldo Anda: Rp $currentSaldo",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedKategori,
                    hint: const Text("Pilih Kategori Pembayaran"),
                    onChanged: (value) {
                      setState(() {
                        selectedKategori = value;
                        jenisController.text = value!;
                      });
                    },
                    items: kategoriList
                        .map((kategori) => DropdownMenuItem(
                              value: kategori,
                              child: Text(kategori),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Kategori",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: tambahKategoriBaru,
                  tooltip: 'Tambah Kategori Baru',
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: jenisController,
              decoration: const InputDecoration(
                labelText: "Jenis Pembayaran",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nomorController,
              decoration: const InputDecoration(
                labelText: "Nomor Rekening / Token",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: nominalController,
              decoration: const InputDecoration(
                labelText: "Nominal",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: lanjutkanPembayaran,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 36, 155),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              ),
              child: const Text(
                "Lanjutkan",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
