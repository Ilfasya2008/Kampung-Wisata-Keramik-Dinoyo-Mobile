class AppConstants {
  static const String appName = 'Kampung Wisata Keramik Dinoyo';
  static const String appSubtitle = 'Portofolio digital & direktori budaya';

  // Koordinat Lokasi Geografis Kampung Keramik Dinoyo Malang
  static const double dinoyoLatitude = -7.942721;
  static const double dinoyoLongitude = 112.607425;
  static const String dinoyoAddress =
      'Jl. MT Haryono IX No.336, Kelurahan Dinoyo, Kecamatan Lowokwaru, Kota Malang, Jawa Timur 65145';
  static const String dinoyoMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=-7.942721,112.607425';
  static const String defaultWhatsApp = '6281234567890';
  static const String contactEmail = 'info@keramikdinoyo.id';

  // Kategori Produk & Workshop
  static const List<String> categories = [
    'Semua Kategori',
    'Semi-Porselen',
    'Gerabah',
    'Galeri Suvenir',
    'Workshop Edukasi',
    'Keramik Hias',
    'Porselen Halus',
  ];

  // AI Prompt Template Constants
  static const String geminiRole =
      'Kamu adalah Kurator Seni Kriya dan Konsultan Budaya Senior Kampung Wisata Keramik Dinoyo Malang. '
      'Tugasmu adalah memberikan wawasan seni, rekomendasi karya keramik, filosofi budaya, estimasi harga, '
      'dan panduan belanja/workshop edukasi untuk pengunjung, kolektor, atau pelajar.';

  static const String geminiConstraint =
      'Analisis WAJIB faktual berbasis kekayaan tradisi Dinoyo (semi-porselen, gerabah tanah liat, glasir suhu tinggi 1200°C, '
      'motif miring khas Dinoyo, perpaduan seni Tiongkok-Jawa sejak 1930). '
      'Gunakan Bahasa Indonesia yang ramah, kultural, dan informatif. '
      'Keluaran WAJIB HANYA berupa JSON valid sesuai output schema tanpa pembuka, penutup, atau tanda markdown wrapper (jangan bungkus dengan ```json). '
      'Jangan berhalusinasi.';

  static const String geminiOutputSchema = '''
{
  "title": "String (Judul insight menarik)",
  "category": "String (Semi-Porselen | Gerabah | Galeri Suvenir | Workshop Edukasi | Porselen Halus)",
  "ceramic_recommendation": "String (Rekomendasi jenis keramik spesifik beserta alasan estetika & fungsional)",
  "cultural_significance": "String (Makna filosofis, sejarah atau keunikan teknik Dinoyo)",
  "estimated_budget": "String (Rentang perkiraan harga dalam Rupiah, misal: Rp 75.000 - Rp 350.000)",
  "care_tips": "String (Tips perawatan atau pemeliharaan keramik tersebut)",
  "recommended_shops": ["String (1-3 nama toko/sanggar di Dinoyo yang cocok)"],
  "key_points": ["String (3 poin kesimpulan ringkas)"]
}
''';
}
