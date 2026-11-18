import '../models/history_era_model.dart';

abstract class HistoryLocalDataSource {
  List<HistoryEraModel> getHistoryTimeline();
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  static const List<HistoryEraModel> _timelineData = [
    HistoryEraModel(
      id: 'era_kanjuruhan',
      chip: 'Abad ke-8 M',
      period: 'Zaman Kuno (760 M)',
      title: 'Akar Budaya Tanah Liat Kerajaan Kanjuruhan',
      description:
          'Kawasan Dinoyo memiliki sejarah peradaban tanah liat yang sangat tua, berakar dari era Kerajaan Kanjuruhan (abad ke-8 Masehi) yang berpusat di sekitar lembah Sungai Metro dan Brantas Malang. Penemuan artefak gerabah biskuit, wadah air suci, dan bata kuno di Situs Candi Badut membuktikan kemahiran masyarakat Dinoyo dalam mengolah lempung tanah liat sejak ribuan tahun lalu.',
      culturalSignificance:
          'Tanah liat Dinoyo yang bersumber dari endapan aluvial Sungai Brantas dipercaya memiliki elastisitas alami yang kokoh dan menyatu dengan spiritualitas masyarakat Jawa kuno.',
      imageAsset: 'assets/images/history_1930.jpg',
      keyMilestones: [
        'Ditemukannya artefak gerabah abad ke-8 di kawasan Dinoyo',
        'Kaitan erat dengan Prasasti Dinoyo bertarikh 760 M',
        'Penggunaan bahan lempung bantaran Sungai Brantas'
      ],
    ),
    HistoryEraModel(
      id: 'era_1930',
      chip: '1930-an',
      period: 'Era Kolonial 1930-an',
      title: 'Rintisan Industri Gerabah Rakyat',
      description:
          'Masyarakat Dinoyo mulai memproduksi gerabah secara massal sebagai mata pencaharian utama warga di luar pertanian. Produk yang dibuat berupa peralatan rumah tangga seperti gentong air, kreweng, kendi, dan cobek dengan teknik meja putar tradisional (throwing) dan pembakaran sekam padi terbuka.',
      culturalSignificance:
          'Awal mula terbentuknya pemukiman perajin yang saling bertetangga dan membentuk etos kerja gotong royong khas "Kampung Gerabah Dinoyo".',
      imageAsset: 'assets/images/history_1930.jpg',
      keyMilestones: [
        'Produksi kendi dan gentong air rumah tangga',
        'Penerapan teknik meja putar manual tradisional',
        'Transformasi warga tani menjadi komunitas perajin'
      ],
    ),
    HistoryEraModel(
      id: 'era_1957',
      chip: '1957',
      period: 'Tahun 1957',
      title: 'Pabrik Percontohan Keramik Dinoyo',
      description:
          'Pemerintah Republik Indonesia melalui Departemen Perindustrian dan Balai Besar Keramik Bandung menetapkan Dinoyo sebagai proyek percontohan nasional. Didirikan pabrik keramik modern dengan bantuan tenaga ahli Jepang dan alumni ITB, memperkenalkan material porselen, kaolin, teknik cetak tuang (slip casting), jiggering, serta tungku pembakaran bersuhu tinggi (1.200°C).',
      culturalSignificance:
          'Momen lompatan teknologi terpenting: transisi dari gerabah tanah liat merah biasa menjadi keramik semi-porselen putih halus yang berdaya tahan tinggi.',
      imageAsset: 'assets/images/history_1957.jpg',
      keyMilestones: [
        'Pembangunan Pabrik Keramik Kerjasama Pemerintah',
        'Pengenalan formula kaolin, feldspar, dan kuarsa',
        'Tungku suhu tinggi 1.200°C pertama di Jawa Timur'
      ],
    ),
    HistoryEraModel(
      id: 'era_keemasan',
      chip: '1980-1990an',
      period: 'Era Keemasan',
      title: 'Masa Kejayaan, Koperasi KOPINKRA & Ekspor',
      description:
          'Dinoyo mencapai puncak keemasannya dengan lebih dari 70 perajin aktif. Dibentuk Koperasi Pengrajin Keramik Dinoyo (KOPINKRA) yang mengoordinasikan pesanan besar. Karya keramik Dinoyo diekspor ke berbagai negara di Eropa (Belanda, Jerman), Jepang, dan Australia, terutama produk vas bunga hias, guci oriental, dan set poci porselen.',
      culturalSignificance:
          'Menjadi sentra keramik nasional kebanggaan Jawa Timur yang sejajar dengan Kasongan Yogyakarta dan Plered Purwakarta.',
      imageAsset: 'assets/images/history_golden.jpg',
      keyMilestones: [
        'Didirikannya Koperasi Industri Keramik (KOPINKRA)',
        'Tembus pasar ekspor Eropa, Jepang, dan Australia',
        'Pemberdayaan lebih dari 70 unit usaha keluarga di satu kampung'
      ],
    ),
    HistoryEraModel(
      id: 'era_warisan_desain',
      chip: 'Warisan Seni',
      period: 'Filosofi Seni',
      title: 'Motif Miring & Akulturasi Tiongkok-Jawa',
      description:
          'Karya Dinoyo memiliki karakter visual yang sangat khas, yaitu "Motif Miring". Motif lukis kuas ini terinspirasi oleh postur dan gestur keanggunan perempuan Jawa saat melukis keramik dengan posisi duduk menyamping miring. Akulturasi estetika Dinasti Ming Tiongkok melahirkan glasir biru-putih (blue and white) dan seladon hijau yang legendaris.',
      culturalSignificance:
          'Motif miring bukan sekadar dekorasi, melainkan cerminan keharmonisan rasa, kesabaran jiwa perajin, dan lambang pertumbuhan yang fleksibel.',
      imageAsset: 'assets/images/history_motif.jpg',
      keyMilestones: [
        'Lahirnya identitas visual "Motif Miring" khas Dinoyo',
        'Pengembangan glasir biru-putih dan retak seribu (crackle)',
        'Pencatatan warisan budaya tak benda Kota Malang'
      ],
    ),
    HistoryEraModel(
      id: 'era_krisis_2003',
      chip: '1998-2003',
      period: 'Era Transformasi',
      title: 'Krisis Moneter, Gasifikasi & Kebangkitan UMKM',
      description:
          'Krisis moneter 1998 dan lonjakan harga minyak tanah menyebabkan pabrik induk sempat berhenti beroperasi pada tahun 2003. Namun perajin lokal tidak menyerah; mereka berinovasi mengonversi tungku pembakaran menjadi berbahan bakar gas LPG dan mendirikan galeri mandiri di depan rumah masing-masing sepanjang Jl. MT Haryono IX.',
      culturalSignificance:
          'Ketangguhan dan kemandirian pengrajin lokal yang berhasil menyelamatkan tradisi keramik Dinoyo dari kepunahan industri modern.',
      imageAsset: 'assets/images/history_krisis.jpg',
      keyMilestones: [
        'Konversi teknologi tungku ke bahan bakar gas LPG ramah lingkungan',
        'Lahirnya puluhan sanggar mandiri skala UMKM',
        'Pembentukan Paguyuban Pengrajin Keramik Dinoyo'
      ],
    ),
    HistoryEraModel(
      id: 'era_kini',
      chip: 'Kini',
      period: '2010 - Sekarang',
      title: 'Kampung Wisata Tematik & Sentra Edu-Tour',
      description:
          'Pemerintah Kota Malang meresmikan kawasan ini sebagai "Kampung Wisata Keramik Dinoyo". Lorong-lorong gang dihias dengan instalasi seni pecahan keramik keramik mozaik, mural edukasi, dan paket workshop interaktif bagi ribuan pelajar sekolah dan wisatawan domestik-internasional setiap tahunnya.',
      culturalSignificance:
          'Keramik Dinoyo hidup kembali bukan hanya sebagai barang dagangan, melainkan sebagai destinasi wisata budaya, laboratorium kriya, dan kebanggaan identitas Kota Malang.',
      imageAsset: 'assets/images/history_kini.jpg',
      keyMilestones: [
        'Peresmian Kampung Wisata Tematik Keramik Dinoyo',
        'Pengembangan paket wisata edukasi (Edu-Tour) meja putar',
        'Integrasi portofolio digital & direktori online untuk pengunjung'
      ],
    ),
  ];

  @override
  List<HistoryEraModel> getHistoryTimeline() => List.unmodifiable(_timelineData);
}
