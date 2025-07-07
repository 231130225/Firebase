import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/artikelModel.dart';
import '../model/headerReuse.dart';
import '../model/paragraphReuse.dart';

class detailArtikelScreen extends StatefulWidget {
  const detailArtikelScreen({super.key});

  @override
  State<detailArtikelScreen> createState() => _detailArtikelScreenState();
}

class _detailArtikelScreenState extends State<detailArtikelScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final artikelProvider = context.watch<ArtikelProvider>();

    return Scaffold(
        appBar: AppBar(
            title: const Text("Detail Artikel"),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[200],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderReuse(
                text: artikelProvider.judul,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Kategori: ${artikelProvider.kategori}",
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Text(
                "Penulis: ${artikelProvider.penulis}",
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Text(
                "Tanggal: ${artikelProvider.tanggal}",
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Paragraph(
                    text: artikelProvider.konten,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}