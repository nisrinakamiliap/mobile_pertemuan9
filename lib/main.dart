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

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Praktikum 7: Data Mahasiswa')),
    body: 

const Center(child: Text('Tahap 0: kerangka aplikasi')),

    );
  }
}
