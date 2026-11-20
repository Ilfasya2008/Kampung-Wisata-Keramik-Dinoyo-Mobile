import 'dart:math' as math;

import 'text_preprocessor.dart';

/// Vektor jarang (sparse): term -> bobot. Term yang tidak ada bernilai 0.
typedef SparseVector = Map<String, double>;

/// Tahap 2 pipeline: TF-IDF (Term Frequency - Inverse Document Frequency).
///
/// * `fit` mempelajari kosakata dan bobot IDF dari korpus dokumen.
/// * `transform` mengubah teks apa pun menjadi vektor TF-IDF ternormalisasi
///   L2, sehingga cosine similarity cukup dihitung dengan dot product.
///
/// Rumus (sama dengan scikit-learn `TfidfVectorizer(sublinear_tf=True,
/// smooth_idf=True)`):
///   tf(t,d)  = 1 + ln(jumlah kemunculan t di d)
///   idf(t)   = ln((1 + N) / (1 + df(t))) + 1
///   w(t,d)   = tf(t,d) * idf(t), lalu vektor dinormalisasi ||w|| = 1
class TfIdfVectorizer {
  TfIdfVectorizer({this.preprocessor = const TextPreprocessor()});

  final TextPreprocessor preprocessor;

  Map<String, double> _idf = const {};
  int _documentCount = 0;

  /// Bobot IDF hasil pembelajaran (read-only), berguna untuk inspeksi/laporan.
  Map<String, double> get idf => Map.unmodifiable(_idf);
  int get documentCount => _documentCount;
  int get vocabularySize => _idf.length;
  bool get isFitted => _documentCount > 0;

  /// Mempelajari kosakata + IDF dari [documents].
  void fit(List<String> documents) {
    final df = <String, int>{};
    for (final doc in documents) {
      for (final term in preprocessor.tokenize(doc).toSet()) {
        df[term] = (df[term] ?? 0) + 1;
      }
    }
    final n = documents.length;
    _documentCount = n;
    _idf = {
      for (final e in df.entries)
        e.key: math.log((1 + n) / (1 + e.value)) + 1,
    };
  }

  /// Mengubah [text] menjadi vektor TF-IDF. Term di luar kosakata diabaikan.
  SparseVector transform(String text) {
    if (!isFitted) {
      throw StateError('TfIdfVectorizer harus di-fit sebelum transform.');
    }
    final counts = <String, int>{};
    for (final term in preprocessor.tokenize(text)) {
      if (_idf.containsKey(term)) counts[term] = (counts[term] ?? 0) + 1;
    }
    final vec = <String, double>{
      for (final e in counts.entries)
        e.key: (1 + math.log(e.value)) * _idf[e.key]!,
    };
    return _l2Normalize(vec);
  }

  List<SparseVector> fitTransform(List<String> documents) {
    fit(documents);
    return [for (final d in documents) transform(d)];
  }

  static SparseVector _l2Normalize(SparseVector v) {
    final norm = math.sqrt(v.values.fold(0.0, (s, x) => s + x * x));
    if (norm == 0) return v;
    return {for (final e in v.entries) e.key: e.value / norm};
  }

  /// Cosine similarity dua vektor yang sudah ternormalisasi L2 (0..1).
  static double cosine(SparseVector a, SparseVector b) {
    final (small, large) = a.length <= b.length ? (a, b) : (b, a);
    var dot = 0.0;
    small.forEach((term, w) {
      final other = large[term];
      if (other != null) dot += w * other;
    });
    return dot;
  }

  /// Term yang paling besar kontribusinya terhadap kemiripan [a] dan [b].
  static List<String> topSharedTerms(SparseVector a, SparseVector b,
      {int limit = 3}) {
    final shared = <MapEntry<String, double>>[
      for (final e in a.entries)
        if (b.containsKey(e.key)) MapEntry(e.key, e.value * b[e.key]!),
    ]..sort((x, y) => y.value.compareTo(x.value));
    return [for (final e in shared.take(limit)) e.key];
  }
}
