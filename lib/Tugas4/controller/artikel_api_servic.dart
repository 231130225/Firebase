import 'package:dio/dio.dart';

class ArtikelApiService {
  final Dio _dio = Dio();
  final String Url = "https://686aa93de559eba908709855.mockapi.io/Berita";

  Future<List<dynamic>> getArticles() async {
    try {
      final response = await _dio.get(Url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Gagal memuat artikel: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Error koneksi saat memuat artikel: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat memuat artikel: $e");
    }
  }

  Future<Map<String, dynamic>> getArticleById(String id) async {
    try {
      final response = await _dio.get("$Url/$id");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Gagal memuat detail artikel: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Error koneksi saat memuat detail artikel: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat memuat detail artikel: $e");
    }
  }

  Future<Map<String, dynamic>> createArticle(Map<String, dynamic> articleData) async {
    try {
      final response = await _dio.post(Url, data: articleData);
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Gagal membuat artikel: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Error koneksi saat membuat artikel: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat membuat artikel: $e");
    }
  }

  Future<Map<String, dynamic>> updateArticle(String id, Map<String, dynamic> articleData) async {
    try {
      final response = await _dio.put("$Url/$id", data: articleData);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Gagal mengupdate artikel: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Error koneksi saat mengupdate artikel: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat mengupdate artikel: $e");
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      final response = await _dio.delete("$Url/$id");
      if (response.statusCode == 200) {
        print("Artikel dengan ID $id berhasil dihapus.");
      } else {
        throw Exception("Gagal menghapus artikel: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Error koneksi saat menghapus artikel: ${e.message}");
    } catch (e) {
      throw Exception("Terjadi kesalahan saat menghapus artikel: $e");
    }
  }
}