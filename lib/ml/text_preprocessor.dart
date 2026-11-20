/// Tahap 1 pipeline NLP: mengubah teks bahasa Indonesia mentah menjadi
/// daftar token yang siap divektorisasi.
///
/// Langkah: case folding -> normalisasi frasa (reduplikasi & kata majemuk)
/// -> tokenisasi -> hapus stopword -> stemming ringan (-nya) -> normalisasi
/// sinonim domain keramik.
class TextPreprocessor {
  const TextPreprocessor();

  /// Frasa yang harus dinormalisasi sebelum teks dipecah per kata.
  static const Map<String, String> _phrases = {
    'oleh-oleh': 'suvenir',
    'oleh oleh': 'suvenir',
    'cendera mata': 'suvenir',
    'tanah liat': 'tanahliat',
    'meja putar': 'mejaputar',
    'anak-anak': 'anak',
  };

  /// Sinonim/variasi ejaan -> bentuk baku, supaya kueri pengguna dan
  /// deskripsi toko yang memakai kata berbeda tetap bertemu.
  static const Map<String, String> _synonyms = {
    'souvenir': 'suvenir',
    'cenderamata': 'suvenir',
    'cinderamata': 'suvenir',
    'kursus': 'workshop',
    'kelas': 'workshop',
    'pelatihan': 'workshop',
    'praktik': 'workshop',
    'praktek': 'workshop',
    'belajar': 'workshop',
    'edukasi': 'workshop',
    'porselin': 'porselen',
    'tembikar': 'gerabah',
    'lempung': 'tanahliat',
    'terjangkau': 'murah',
    'hemat': 'murah',
    'kado': 'hadiah',
    'cafe': 'kafe',
    'resto': 'restoran',
    'nikah': 'pernikahan',
    'wedding': 'pernikahan',
    'hiasan': 'hias',
    'dekorasi': 'hias',
    'pajangan': 'hias',
    'siswa': 'sekolah',
    'pelajar': 'sekolah',
    'murid': 'sekolah',
    'kuliah': 'mahasiswa',
    'grup': 'rombongan',
    'group': 'rombongan',
    'borongan': 'grosir',
    'gelas': 'cangkir',
    'mug': 'cangkir',
  };

  /// Stopword bahasa Indonesia (kata fungsi yang tidak membawa makna topik).
  static const Set<String> stopwords = {
    'yang', 'dan', 'di', 'ke', 'dari', 'untuk', 'dengan', 'atau', 'ini',
    'itu', 'ada', 'saya', 'aku', 'kami', 'kita', 'mau', 'ingin', 'cari',
    'mencari', 'pengen', 'pingin', 'buat', 'sebuah', 'suatu', 'juga', 'bisa',
    'dapat', 'akan', 'pada', 'dalam', 'para', 'oleh', 'serta', 'hingga',
    'sejak', 'sebagai', 'berupa', 'tersebut', 'tempat', 'apa', 'mana', 'yg',
    'dgn', 'utk', 'dong', 'deh', 'nih', 'sih', 'aja', 'saja', 'tolong',
    'mohon', 'sangat', 'lebih', 'paling', 'bagus', 'bagi', 'agar', 'supaya',
    'karena', 'jadi', 'kalau', 'jika', 'tapi', 'tetapi', 'namun', 'lalu',
    'kemudian', 'minimal', 'sendiri', 'bersama', 'rutin', 'dikenal',
    'berdiri', 'yaitu', 'adalah', 'seperti', 'cocok', 'khas', 'berbagai',
    'sebelumnya', 'sehari', 'tidak', 'belum', 'sudah', 'punya', 'toko',
    'ikut', 'langsung', 'boleh', 'dimana', 'yuk',
  };

  static final RegExp _nonAlnum = RegExp(r'[^a-z0-9]+');
  static final RegExp _numeric = RegExp(r'^[0-9]+$');

  List<String> tokenize(String text) {
    var t = text.toLowerCase();
    _phrases.forEach((from, to) => t = t.replaceAll(from, to));

    final out = <String>[];
    for (var tok in t.split(_nonAlnum)) {
      if (tok.length < 2 || _numeric.hasMatch(tok)) continue;
      if (stopwords.contains(tok)) continue;
      if (tok.length > 6 && tok.endsWith('nya')) {
        tok = tok.substring(0, tok.length - 3);
      }
      out.add(_synonyms[tok] ?? tok);
    }
    return out;
  }

  /// Bentuk yang ramah dibaca untuk token hasil normalisasi.
  static String display(String token) => switch (token) {
        'tanahliat' => 'tanah liat',
        'mejaputar' => 'meja putar',
        _ => token,
      };
}
