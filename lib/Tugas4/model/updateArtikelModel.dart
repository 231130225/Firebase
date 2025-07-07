import 'package:flutter/material.dart';

class UpdateArtikelProvider extends ChangeNotifier {
  String _konten = "";
  String _kategoriId = "";
  String _penulis = "";
  String _tanggal = "";
  String get konten => _konten;
  String get kategoriId => _kategoriId;
  String get penulis => _penulis;
  String get tanggal => _tanggal;

  void setKonten(String value) {
    _konten = value;
    notifyListeners();
  }
  void setKategori(String value) {
    _kategoriId = value;
    notifyListeners();
  }
  void setPenulis(String value) {
    _penulis = value;
    notifyListeners();
  }
  void setTanggal(String value) {
    _tanggal = value;
    notifyListeners();
  }
  void reset() {
    _konten = "";
    _kategoriId = "";
    _penulis = "";
    _tanggal = "";
  }
}