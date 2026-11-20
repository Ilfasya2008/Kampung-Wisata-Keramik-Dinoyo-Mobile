import 'package:flutter_test/flutter_test.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/data/dummy_data.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/ml/shop_recommender.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/ml/text_preprocessor.dart';
import 'package:kampung_wisata_keramik_dinoyo_app/ml/tfidf_vectorizer.dart';

/// Data uji: kueri pengguna -> toko yang dinilai relevan (label manual).
/// Sebagian kueri sengaja memakai kata yang TIDAK ada di data toko
/// (sinonim / parafrase) untuk menguji generalisasi.
const evaluationSet = <(String, Set<String>)>[
  ('belajar membuat gerabah dari tanah liat', {'ibu-sri'}),
  ('oleh-oleh murah khas Malang', {'melati'}),
  ('hadiah cangkir teh porselen', {'galeri-porselen'}),
  ('piring untuk kafe, pesan grosir', {'tiga-putra'}),
  ('vas semi-porselen motif ukir bunga', {'sari-asih'}),
  ('workshop melukis keramik untuk rombongan sekolah', {'sari-asih', 'ibu-sri'}),
  ('suvenir pernikahan', {'melati'}),
  ('pot tanaman tanah liat', {'ibu-sri'}),
  ('cangkir kopi dengan logo usaha', {'tiga-putra'}),
  ('piring hias lukis tangan untuk koleksi', {'galeri-porselen'}),
  ('kendi air tradisional', {'ibu-sri'}),
  ('magnet kulkas', {'melati'}),
  // Parafrase / sinonim:
  ('kursus tembikar untuk murid SD', {'ibu-sri', 'sari-asih'}),
  ('souvenir cinderamata acara kantor', {'melati'}),
  ('perlengkapan makan untuk resto dan hotel', {'tiga-putra'}),
];

void main() {
  group('TextPreprocessor', () {
    const pre = TextPreprocessor();

    test('case folding, stopword, dan sinonim', () {
      expect(pre.tokenize('Saya INGIN Kursus Tembikar di Dinoyo'),
          ['workshop', 'gerabah', 'dinoyo']);
    });

    test('reduplikasi & frasa majemuk dinormalisasi', () {
      expect(pre.tokenize('oleh-oleh dari tanah liat'),
          ['suvenir', 'tanahliat']);
    });
  });

  group('TfIdfVectorizer', () {
    final v = TfIdfVectorizer()
      ..fit(['gerabah tanah liat', 'porselen halus', 'gerabah porselen']);

    test('IDF lebih besar untuk term yang jarang', () {
      // "halus" muncul di 1 dokumen, "gerabah" di 2 dokumen.
      expect(v.idf['halus']!, greaterThan(v.idf['gerabah']!));
    });

    test('vektor ternormalisasi & cosine(x, x) = 1', () {
      final a = v.transform('gerabah tanah liat');
      expect(TfIdfVectorizer.cosine(a, a), closeTo(1.0, 1e-9));
    });

    test('dokumen tanpa term bersama -> cosine 0', () {
      final a = v.transform('tanah liat');
      final b = v.transform('porselen halus');
      expect(TfIdfVectorizer.cosine(a, b), 0);
    });
  });

  group('ShopRecommender', () {
    final model = ShopRecommender(dummyShops);

    test('toko nonaktif tidak pernah direkomendasikan', () {
      final r = model.recommend('lampu keramik hias dekorasi interior');
      expect(r.any((x) => x.shop.id == 'rumah-kriya'), isFalse);
    });

    test('kueri kosong / tidak dikenal -> tanpa hasil', () {
      expect(model.recommend(''), isEmpty);
      expect(model.recommend('xyz qwerty'), isEmpty);
    });

    test('toko tanpa workshop tidak muncul untuk kueri workshop', () {
      final ids = model.recommend('ikut workshop').map((r) => r.shop.id);
      expect(ids, isNot(contains('melati')));
      expect(ids, isNot(contains('tiga-putra')));
    });

    test('Toko Serupa tidak memuat toko itu sendiri', () {
      final shop = dummyShops.first;
      final r = model.similarTo(shop);
      expect(r, isNotEmpty);
      expect(r.any((x) => x.shop.id == shop.id), isFalse);
    });

    test('evaluasi: Hit@1, Hit@3, MRR pada ${evaluationSet.length} kueri uji',
        () {
      var hit1 = 0, hit3 = 0;
      var mrr = 0.0;
      final lines = <String>[];
      for (final (query, relevant) in evaluationSet) {
        final ranked = model.recommend(query, limit: 5);
        final rank = ranked.indexWhere((r) => relevant.contains(r.shop.id)) + 1;
        if (rank == 1) hit1++;
        if (rank >= 1 && rank <= 3) hit3++;
        if (rank > 0) mrr += 1 / rank;
        final top = ranked.isEmpty
            ? '-'
            : '${ranked.first.shop.id} (${ranked.first.score.toStringAsFixed(2)})';
        lines.add('${rank == 1 ? 'OK ' : 'XX '} rank=${rank == 0 ? '-' : rank}'
            '  "$query" -> top1: $top');
      }
      final n = evaluationSet.length;
      // ignore: avoid_print
      print('\n=== Evaluasi Model Rekomendasi (TF-IDF + Cosine) ===\n'
          '${lines.join('\n')}\n'
          '----------------------------------------------------\n'
          'Korpus  : ${model.vectorizer.documentCount} dokumen toko, '
          '${model.vectorizer.vocabularySize} term\n'
          'Hit@1   : $hit1/$n = ${(hit1 / n * 100).toStringAsFixed(1)}%\n'
          'Hit@3   : $hit3/$n = ${(hit3 / n * 100).toStringAsFixed(1)}%\n'
          'MRR     : ${(mrr / n).toStringAsFixed(3)}\n');

      expect(hit3 / n, greaterThanOrEqualTo(0.9));
      expect(mrr / n, greaterThanOrEqualTo(0.8));
    });
  });
}
