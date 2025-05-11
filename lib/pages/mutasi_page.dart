import 'package:flutter/material.dart';
import '../models/mutasi.dart';

class MutasiPage extends StatelessWidget {
  final List<Mutasi> mutasiList;

  const MutasiPage({super.key, required this.mutasiList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mutasi Transaksi"),
        backgroundColor: const Color.fromARGB(255, 0, 36, 155),
        foregroundColor: Colors.white,
      ),
      body: mutasiList.isEmpty
          ? const Center(child: Text("Belum ada transaksi."))
          : ListView.builder(
              itemCount: mutasiList.length,
              itemBuilder: (context, index) {
                final mutasi = mutasiList[index];
                final isPositive = mutasi.nominal > 0;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    title: Text(mutasi.jenis),
                    trailing: Text(
                      "${isPositive ? '+' : ''}Rp ${mutasi.nominal.abs()}",
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

