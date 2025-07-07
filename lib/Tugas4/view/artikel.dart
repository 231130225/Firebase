import 'package:flutter/material.dart';
import 'package:flutter_firebase/Tugas4/view/login.dart';
import 'package:provider/provider.dart';
import '../model/artikelModel.dart';
import '../controller/artikel_api_servic.dart';
import 'buatArtikel.dart';
import 'detailArtikel.dart';
import 'updateArtikel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArtikelScreen extends StatefulWidget {
  final User? user;

  const ArtikelScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  List<Map<String, dynamic>> _articles = [];
  final ArtikelApiService _apiService = ArtikelApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final List<dynamic> fetchedData = await _apiService.getArticles();
      List<Map<String, dynamic>> articlesWithLikes = [];

      for (var article in fetchedData) {
        final String articleId = article["id"].toString();
        DocumentSnapshot articleDoc = await _firestore.collection('articles').doc(articleId).get();
        int likesCount = 0;
        bool isLikedByUser = false;

        if (articleDoc.exists) {
          Map<String, dynamic> firestoreData = articleDoc.data() as Map<String, dynamic>;
          likesCount = firestoreData['likesCount'] ?? 0;

          DocumentSnapshot likeDoc = await _firestore.collection('articles')
              .doc(articleId)
              .collection('likes')
              .doc(widget.user!.uid)
              .get();
          isLikedByUser = likeDoc.exists;
        } else {
          await _firestore.collection('articles').doc(articleId).set({
            'likesCount': 0,
          });
        }

        articlesWithLikes.add({
          ...article,
          'likesCount': likesCount,
          'isLikedByUser': isLikedByUser,
        });
      }

      if (mounted) {
        setState(() {
          _articles = articlesWithLikes;
          _isLoading = false;
        });
        print('Load data dari MockAPI dan Firestore: ${_articles.length} artikel.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
      print("Loading artikel error: $e");
    }
  }

  Future<void> _deleteArticle(String id) async {
    try {
      await _apiService.deleteArticle(id);

      await _firestore.collection('articles').doc(id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Artikel berhasil dihapus!")),
      );
      _loadArticles();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus artikel: ${e.toString()}")),
      );
      print("Error menghapus artikel: $e");
    }
  }

  Future<void> _toggleLike(String articleId, bool currentlyLiked, int index) async {
    if (widget.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan: Pengguna tidak teridentifikasi.")),
      );
      return;
    }

    final String userId = widget.user!.uid;
    final DocumentReference articleRef = _firestore.collection('articles').doc(articleId);
    final DocumentReference likeRef = articleRef.collection('likes').doc(userId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot currentArticleDoc = await transaction.get(articleRef);

        if (!currentArticleDoc.exists) {
          transaction.set(articleRef, {'likesCount': 0});
          currentArticleDoc = await transaction.get(articleRef);
        }

        int newLikesCount = (currentArticleDoc.data() as Map<String, dynamic>?)?['likesCount'] ?? 0;

        if (currentlyLiked) {
          transaction.delete(likeRef);
          newLikesCount--;
        } else {
          transaction.set(likeRef, {'timestamp': FieldValue.serverTimestamp()});
          newLikesCount++;
        }
        transaction.update(articleRef, {'likesCount': newLikesCount});
      });

      setState(() {
        _articles[index]['isLikedByUser'] = !currentlyLiked;
        _articles[index]['likesCount'] = currentlyLiked
            ? _articles[index]['likesCount'] - 1
            : _articles[index]['likesCount'] + 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(currentlyLiked ? "Unlike berhasil!" : "Like berhasil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memproses like/unlike: ${e.toString()}")),
      );
      print("Error toggling like: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final artikelProvider = context.read<ArtikelProvider>();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            ElevatedButton(
              onPressed: _loadArticles,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (_articles.isEmpty) {
      return const Center(child: Text("Tidak ada artikel."));
    }


    //tampilan
    return Scaffold(
      appBar: AppBar(
          title: Text("Halo, ${widget.user?.displayName ?? 'Pengguna'} | Berita A13"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[200],
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                icon: Icon(Icons.logout))
          ],
      ),
      body: ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          final String articleId = article["id"].toString();
          final bool isLiked = article['isLikedByUser'] ?? false;
          final int likesCount = article['likesCount'] ?? 0;

          return ListTile(
            title: Text(article["judul"] ?? "Tidak ada judul"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article["konten"] ?? "Tidak ada konten", maxLines: 2),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('$likesCount Likes'),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                    color: isLiked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => _toggleLike(articleId, isLiked, index),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const updateArtikel(),
                        settings: RouteSettings(arguments: articleId),
                      ),
                    );
                    if (result == true) {
                      _loadArticles();
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteArticle(articleId),
                ),
              ],
            ),
            onTap: () {
              artikelProvider.setJudul(article["judul"] ?? "");
              artikelProvider.setKonten(article["konten"] ?? "");
              artikelProvider.setKategori(article["kategori"] ?? "");
              artikelProvider.setPenulis(article["penulis"] ?? "");
              artikelProvider.setTanggal(article["tanggal"] ?? "");

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const detailArtikelScreen()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const buatArtikel()),
          );
          if (result == true) {
            _loadArticles();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}