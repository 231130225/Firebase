import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/updateArtikelModel.dart';
import '../controller/artikel_api_servic.dart';

class updateArtikel extends StatefulWidget {
  const updateArtikel({super.key});

  @override
  State<updateArtikel> createState() => _updateArtikelState();
}

enum Kategori { berita, politik, pendidikan, olahraga, redaksi }

class _updateArtikelState extends State<updateArtikel> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _kontenController = TextEditingController();

  Kategori? _selectedKategori;
  final ArtikelApiService _apiService = ArtikelApiService();

  String? _artikelId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _artikelId = ModalRoute.of(context)!.settings.arguments as String?;
      if (_artikelId != null) {
        _loadArticleData(_artikelId!);
      } else {
        print("Error: ID artikel null.");
        Navigator.pop(context, false);
      }
    });
  }

  Future<void> _loadArticleData(String id) async {
    try {
      final data = await _apiService.getArticleById(id);
      if (mounted) {
        setState(() {
          _judulController.text = data["judul"] ?? "";
          _penulisController.text = data["penulis"] ?? "";
          _tanggalController.text = data["tanggal"] ?? "";
          _kontenController.text = data["konten"] ?? "";

          String kategoriDariAPI = data["kategori"] ?? "Berita";
          _selectedKategori = _getKategoriEnum(kategoriDariAPI);

          final updateArtikelProvider = context.read<UpdateArtikelProvider>();
          updateArtikelProvider.setPenulis(_penulisController.text);
          updateArtikelProvider.setTanggal(_tanggalController.text);
          updateArtikelProvider.setKonten(_kontenController.text);
          updateArtikelProvider.setKategori(_getKategoriString(_selectedKategori));
        });
      }
    } catch (e) {
      print("loading artikel error untuk diedit: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data artikel: ${e.toString()}")),
      );
      Navigator.pop(context, false);
    }
  }

  String _getKategoriString(Kategori? kategori) {
    switch (kategori) {
      case Kategori.berita: return "Berita";
      case Kategori.politik: return "Politik";
      case Kategori.pendidikan: return "Pendidikan";
      case Kategori.olahraga: return "Olahraga";
      case Kategori.redaksi: return "Redaksi";
      default: return "Berita";
    }
  }

  Kategori? _getKategoriEnum(String kategoriString) {
    switch (kategoriString) {
      case "Berita": return Kategori.berita;
      case "Politik": return Kategori.politik;
      case "Pendidikan": return Kategori.pendidikan;
      case "Olahraga": return Kategori.olahraga;
      case "Redaksi": return Kategori.redaksi;
      default: return Kategori.berita;
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
    final updateArtikelProvider = context.read<UpdateArtikelProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Artikel"),
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
                enabled: false,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _penulisController,
                decoration: const InputDecoration(labelText: "Penulis Artikel", border: OutlineInputBorder()),
                onChanged: (value) => updateArtikelProvider.setPenulis(value),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _tanggalController,
                decoration: const InputDecoration(labelText: "Tanggal Artikel Dibuat (contoh: 01-01-2025)", border: OutlineInputBorder()),
                onChanged: (value) => updateArtikelProvider.setTanggal(value),
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
                          updateArtikelProvider.setKategori(_getKategoriString(value));
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
                onChanged: (value) => updateArtikelProvider.setKonten(value),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_artikelId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ID artikel tidak ditemukan untuk diedit.")),
                    );
                    return;
                  }

                  final Map<String, dynamic> updatedArticleData = {
                    "judul": _judulController.text,
                    "penulis": updateArtikelProvider.penulis,
                    "tanggal": updateArtikelProvider.tanggal,
                    "kategori": updateArtikelProvider.kategoriId,
                    "konten": updateArtikelProvider.konten,
                  };

                  try {
                    await _apiService.updateArticle(_artikelId!, updatedArticleData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Artikel berhasil diedit!")),
                    );
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal mengedit artikel: ${e.toString()}")),
                    );
                    print("Error mengedit artikel: $e");
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Artikel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}