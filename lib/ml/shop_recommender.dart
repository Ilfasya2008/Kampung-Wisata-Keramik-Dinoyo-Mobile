import '../data/dummy_data.dart';
import '../data/models.dart';
import 'text_preprocessor.dart';
import 'tfidf_vectorizer.dart';

/// Satu hasil rekomendasi: toko, skor cosine similarity (0..1), dan term
/// yang menjadi alasan kecocokan (explainability).
class Recommendation {
  const Recommendation({
    required this.shop,
    required this.score,
    required this.reasons,
  });

  final Shop shop;
  final double score;
  final List<String> reasons;

  int get percent => (score * 100).round();
}

/// Tahap 3 pipeline: sistem rekomendasi content-based filtering.
///
/// Setiap toko direpresentasikan sebagai satu dokumen teks (profil + katalog
/// produk). Model TF-IDF di-fit pada seluruh dokumen toko, lalu:
///  * [recommend]  : kueri bebas pengguna -> toko paling relevan.
///  * [similarTo]  : toko -> toko lain yang paling mirip ("Toko Serupa").
class ShopRecommender {
  ShopRecommender(
    List<Shop> shops, {
    this.catalog = productsOf,
    TfIdfVectorizer? vectorizer,
  })  : shops = List.unmodifiable(shops),
        vectorizer = vectorizer ?? TfIdfVectorizer() {
    _train();
  }

  /// Model bersama untuk seluruh aplikasi, dilatih dari data toko.
  static final ShopRecommender instance = ShopRecommender(dummyShops);

  final List<Shop> shops;
  final TfIdfVectorizer vectorizer;
  /// Sumber katalog produk per toko (bisa diganti saat pengujian).
  final List<Product> Function(String shopId) catalog;
  late final List<SparseVector> _shopVectors;

  /// Skor minimum agar sebuah toko dianggap relevan.
  static const double minScore = 0.05;

  /// Menyusun dokumen teks untuk satu toko. Field penting diulang
  /// (field weighting) agar bobotnya lebih besar.
  String documentFor(Shop s) {
    final workshopText = switch (s.workshop) {
      WorkshopStatus.tersedia => 'workshop tersedia',
      WorkshopStatus.reservasi => 'workshop reservasi',
      // Jangan memasukkan kata "workshop" untuk toko tanpa workshop.
      WorkshopStatus.tidakTersedia => '',
    };
    final products = catalog(s.id)
        .map((p) => '${p.name} ${p.description} ${p.category}')
        .join(' ');
    return [
      s.name,
      s.specialty, s.specialty, s.specialty, // bobot x3
      ...s.categoryKeys, ...s.categoryKeys, // bobot x2
      workshopText,
      s.about,
      products,
    ].join(' ');
  }

  void _train() {
    _shopVectors = vectorizer.fitTransform([for (final s in shops) documentFor(s)]);
  }

  /// Rekomendasi toko berdasarkan teks kebutuhan pengguna.
  List<Recommendation> recommend(
    String query, {
    int limit = 5,
    bool activeOnly = true,
  }) {
    if (query.trim().isEmpty) return const [];
    final q = vectorizer.transform(query);
    if (q.isEmpty) return const [];
    return _rank(q, limit: limit, activeOnly: activeOnly);
  }

  /// Toko lain yang paling mirip dengan [shop] (item-to-item).
  List<Recommendation> similarTo(Shop shop, {int limit = 3}) {
    final i = shops.indexWhere((s) => s.id == shop.id);
    final v = i >= 0 ? _shopVectors[i] : vectorizer.transform(documentFor(shop));
    return _rank(v, limit: limit, activeOnly: true, excludeId: shop.id);
  }

  List<Recommendation> _rank(
    SparseVector v, {
    required int limit,
    required bool activeOnly,
    String? excludeId,
  }) {
    final results = <Recommendation>[];
    for (var i = 0; i < shops.length; i++) {
      final s = shops[i];
      if (s.id == excludeId || (activeOnly && !s.active)) continue;
      final score = TfIdfVectorizer.cosine(v, _shopVectors[i]);
      if (score < minScore) continue;
      results.add(Recommendation(
        shop: s,
        score: score,
        reasons: [
          for (final t in TfIdfVectorizer.topSharedTerms(v, _shopVectors[i]))
            TextPreprocessor.display(t),
        ],
      ));
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(limit).toList();
  }
}
