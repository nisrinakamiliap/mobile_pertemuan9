
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
  // TAHAP 6: Pencarian data.
  String keyword = '';

  List<Map<String, String>> get dataTampil {
    final q = keyword.trim().toLowerCase();

    return mahasiswa.where((m) =>
      m['nama']!.toLowerCase().contains(q) ||
      m['nim']!.toLowerCase().contains(q)
    ).toList();
  }

  // TAHAP 3: CREATE. Form mengembalikan data baru.
  Future<void> tambahData() async {
    final hasil = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MahasiswaForm(dataSudahAda: mahasiswa),
    );

    if (!mounted || hasil == null) return;

    setState(() {
      mahasiswa.add({'id': '${nextId++}', ...hasil});
    });
  }

  // TAHAP 4: UPDATE berdasarkan id, BUKAN indeks ListView.
  Future<void> ubahData(Map<String, String> dipilih) async {
    final hasil = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => MahasiswaForm(
        dataAwal: dipilih,
        dataSudahAda: mahasiswa,
      ),
    );

    if (!mounted || hasil == null) return;

    final index = mahasiswa.indexWhere(
      (m) => m['id'] == dipilih['id'],
    );

    if (index < 0) return;

    setState(() {
      mahasiswa[index] = {'id': dipilih['id']!, ...hasil};
    });
  }

  // TAHAP 5: DELETE dengan dialog konfirmasi.
  Future<void> hapusData(Map<String, String> dipilih) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus data?'),
        content: Text('Hapus ${dipilih['nama']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || setuju != true) return;

    setState(() {
      mahasiswa.removeWhere((m) => m['id'] == dipilih['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 7: Data Mahasiswa'),
      ),

      body: Column(
        children: [
          // TAHAP 6: Kolom pencarian.
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari nama atau NIM',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => keyword = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataTampil.length,
              itemBuilder: (context, index) {
                final item = dataTampil[index];

                return Card(
                  child: ListTile(
                    title: Text(item['nama']!),
                    subtitle: Text(
                      '${item['nim']} | ${item['prodi']}',
                    ),

                    // TAHAP 4 dan 5: Tombol Edit dan Hapus.
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Ubah',
                          icon: const Icon(Icons.edit),
                          onPressed: () => ubahData(item),
                        ),

                        IconButton(
                          tooltip: 'Hapus',
                          icon: const Icon(Icons.delete),
                          onPressed: () => hapusData(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahData,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

// Form dipisahkan menjadi widget agar controller memiliki lifecycle yang benar.
class MahasiswaForm extends StatefulWidget {
  final Map<String, String>? dataAwal;
  final List<Map<String, String>> dataSudahAda;

  const MahasiswaForm({
    super.key,
    this.dataAwal,
    required this.dataSudahAda,
  });

  @override
  State<MahasiswaForm> createState() => _MahasiswaFormState();
}

class _MahasiswaFormState extends State<MahasiswaForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nim;
  late final TextEditingController nama;
  late final TextEditingController prodi;

  @override
  void initState() {
    super.initState();

    nim = TextEditingController(
      text: widget.dataAwal?['nim'] ?? '',
    );

    nama = TextEditingController(
      text: widget.dataAwal?['nama'] ?? '',
    );

    prodi = TextEditingController(
      text: widget.dataAwal?['prodi'] ?? '',
    );
  }

  @override
  void dispose() {
    nim.dispose();
    nama.dispose();
    prodi.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.dataAwal == null ? 'Tambah Data' : 'Ubah Data',
      ),

      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nim,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';

                  if (v.isEmpty) {
                    return 'NIM wajib diisi';
                  }

                  final sudahAda = widget.dataSudahAda.any((m) =>
                    m['nim'] == v &&
                    m['id'] != widget.dataAwal?['id']
                  );

                  if (sudahAda) {
                    return 'NIM sudah digunakan';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: nama,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (v) =>
                  (v == null || v.trim().isEmpty)
                    ? 'Nama wajib diisi'
                    : null,
              ),

              TextFormField(
                controller: prodi,
                decoration: const InputDecoration(
                  labelText: 'Prodi',
                ),
                validator: (v) =>
                  (v == null || v.trim().isEmpty)
                    ? 'Prodi wajib diisi'
                    : null,
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),

        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            Navigator.pop(context, {
              'nim': nim.text.trim(),
              'nama': nama.text.trim(),
              'prodi': prodi.text.trim(),
            });
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
