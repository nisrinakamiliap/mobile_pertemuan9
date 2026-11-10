
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MahasiswaPage(),
));

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {

  // TAHAP 1: Inisialisasi data sementara di RAM.
  final List<Map<String, String>> mahasiswa = [
    {'id': '1', 'nim': '2026001', 'nama': 'Andi', 'prodi': 'Informatika'},
    {'id': '2', 'nim': '2026002', 'nama': 'Siti', 'prodi': 'Informatika'},
  ];

  int nextId = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 7: Data Mahasiswa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Data tersimpan: ${mahasiswa.length}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mahasiswa.length,
              itemBuilder: (context, index) {
                final item = mahasiswa[index];

                return Card(
                  child: ListTile(
                    title: Text(item['nama']!),
                    subtitle: Text(
                      '${item['nim']} | ${item['prodi']}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
