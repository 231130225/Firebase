import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/createArtikelModel.dart';
import '../controller/artikel_api_servic.dart';

class buatArtikel extends StatefulWidget {
  const buatArtikel({super.key});

  @override
  State<buatArtikel> createState() => _buatArtikelState();
}

enum Kategori { berita, politik, pendidikan, olahraga, redaksi }

class _buatArtikelState extends State<buatArtikel> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _kontenController = TextEditingController();

  Kategori? _selectedKategori = Kategori.berita;
  final ArtikelApiService _apiService = ArtikelApiService();

  String _getKategoriString(Kategori? kategori) {
    switch (kategori) {
      case Kategori.berita:
        return "Berita";
      case Kategori.politik:
        return "Politik";
      case Kategori.pendidikan:
        return "Pendidikan";
      case Kategori.olahraga:
        return "Olahraga";
      case Kategori.redaksi:
        return "Redaksi";
      default:
        return "Berita";
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _tanggalController.dispose();
    _kontenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buatArtikelProvider = context.read<CreateArtikelProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      buatArtikelProvider.setKategori(_getKategoriString(_selectedKategori));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Artikel"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: "Judul Artikel", border: OutlineInputBorder()),
                onChanged: (value) => buatArtikelProvider.setJudul(value),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _penulisController,
                decoration: const InputDecoration(labelText: "Penulis Artikel", border: OutlineInputBorder()),
                onChanged: (value) => buatArtikelProvider.setPenulis(value),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _tanggalController,
                decoration: const InputDecoration(labelText: "Tanggal Artikel Dibuat (contoh: 01-01-2025)", border: OutlineInputBorder()),
                onChanged: (value) => buatArtikelProvider.setTanggal(value),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kategori:", style: TextStyle(fontSize: 16)),
                  ...Kategori.values.map((kategoriEnum) {
                    return RadioListTile<Kategori>(
                      title: Text(_getKategoriString(kategoriEnum)),
                      value: kategoriEnum,
                      groupValue: _selectedKategori,
                      onChanged: (Kategori? value) {
                        setState(() {
                          _selectedKategori = value;
                          buatArtikelProvider.setKategori(_getKategoriString(value));
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _kontenController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Isi Artikel", border: OutlineInputBorder()),
                onChanged: (value) => buatArtikelProvider.setKonten(value),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final Map<String, dynamic> newArticleData = {
                    "judul": buatArtikelProvider.judul,
                    "penulis": buatArtikelProvider.penulis,
                    "tanggal": buatArtikelProvider.tanggal,
                    "kategori": buatArtikelProvider.kategoriId,
                    "konten": buatArtikelProvider.konten,
                  };

                  try {
                    await _apiService.createArticle(newArticleData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Artikel berhasil dibuat!")),
                    );
                    buatArtikelProvider.reset();
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal membuat artikel: ${e.toString()}")),
                    );
                    print("Error membuat artikel: $e");
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Simpan Artikel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}