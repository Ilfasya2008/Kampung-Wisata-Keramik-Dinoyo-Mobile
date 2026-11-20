import 'models.dart';

/// Total number of registered shops shown in the design ("dari 30").
const int kTotalShops = 30;

const List<String> kCategories = [
  'Semua Kategori',
  'Semi-Porselen',
  'Gerabah',
  'Galeri Suvenir',
  'Workshop Edukasi',
];

/// Data toko. Teks `about` dan katalog produk di [shopProducts] juga dipakai
/// sebagai korpus oleh model rekomendasi (lib/ml/shop_recommender.dart).
const List<Shop> dummyShops = [
  Shop(
    id: 'sari-asih',
    name: 'Toko Keramik Sari Asih',
    specialty: 'Semi-Porselen',
    address: 'Jl. MT Haryono IX No.12',
    hours: '08.00-16.00 WIB',
    workshop: WorkshopStatus.tersedia,
    categoryKeys: ['Semi-Porselen', 'Workshop Edukasi'],
    established: '1962',
    about:
        'Toko keluarga yang berdiri sejak 1962 dan dikenal dengan vas serta guci semi-porselen bermotif ukir bunga khas Jawa. Pengunjung dan rombongan sekolah bisa langsung ikut workshop membentuk tanah liat, melukis motif, hingga proses glasir bersama pengrajin.',
  ),
  Shop(
    id: 'galeri-porselen',
    name: 'Galeri Porselen Dinoyo',
    specialty: 'Porselen Halus',
    address: 'Jl. MT Haryono IX No.45',
    hours: '09.00-17.00 WIB',
    workshop: WorkshopStatus.reservasi,
    categoryKeys: ['Semi-Porselen', 'Galeri Suvenir', 'Workshop Edukasi'],
    about:
        'Galeri yang memajang porselen halus berkualitas ekspor: set cangkir teh, piring hias, dan vas putih tipis berglasir mengilap. Cocok untuk hadiah, koleksi, dan cendera mata premium. Kelas melukis porselen tersedia dengan reservasi minimal sehari sebelumnya.',
  ),
  Shop(
    id: 'ibu-sri',
    name: 'Sanggar Gerabah Ibu Sri',
    specialty: 'Gerabah Tradisional',
    address: 'Jl. Dinoyo Gang III No.8',
    hours: '08.00-15.00 WIB',
    workshop: WorkshopStatus.tersedia,
    categoryKeys: ['Gerabah', 'Workshop Edukasi'],
    about:
        'Sanggar gerabah tradisional dari tanah liat merah yang dibentuk dengan teknik meja putar dan pijat. Ibu Sri rutin membuka kelas belajar membuat gerabah untuk anak sekolah, mahasiswa, dan wisatawan dengan harga terjangkau.',
  ),
  Shop(
    id: 'tiga-putra',
    name: 'Keramik Tiga Putra',
    specialty: 'Semi-Porselen & Gerabah',
    address: 'Jl. MT Haryono IX No.78',
    hours: '09.00-16.00 WIB',
    workshop: WorkshopStatus.tidakTersedia,
    categoryKeys: ['Semi-Porselen', 'Gerabah'],
    about:
        'Produsen keramik dalam jumlah besar untuk kebutuhan hotel, restoran, dan kafe: piring, mangkuk, dan cangkir. Menerima pesanan custom logo serta pembelian grosir dengan harga pabrik.',
  ),
  Shop(
    id: 'rumah-kriya',
    name: 'Rumah Kriya Keramik',
    specialty: 'Keramik Hias',
    address: 'Jl. Dinoyo Gang V No.3',
    hours: '10.00-17.00 WIB',
    workshop: WorkshopStatus.tersedia,
    categoryKeys: ['Galeri Suvenir', 'Workshop Edukasi'],
    about:
        'Studio keramik hias kontemporer: patung mini, hiasan dinding, dan lampu keramik untuk dekorasi interior rumah. Menyediakan workshop kreatif untuk komunitas dan keluarga.',
    active: false,
  ),
  Shop(
    id: 'melati',
    name: 'Toko Suvenir Melati',
    specialty: 'Suvenir Keramik',
    address: 'Jl. MT Haryono IX No.90',
    hours: '08.00-18.00 WIB',
    workshop: WorkshopStatus.tidakTersedia,
    categoryKeys: ['Galeri Suvenir'],
    about:
        'Pusat oleh-oleh khas Malang berupa suvenir keramik murah: gantungan kunci, magnet kulkas, asbak mini, dan miniatur Tugu Malang. Melayani pesanan suvenir pernikahan dan cendera mata acara kantor dalam jumlah banyak.',
  ),
];

/// Katalog default (dipakai bila toko belum punya katalog sendiri).
const List<Product> dummyProducts = [
  Product(
    name: 'Vas Bunga Ukir Klasik',
    description: 'Motif ukir bunga tradisional Jawa, tinggi 30cm',
    category: 'Semi-Porselen',
    price: 'Rp 150.000',
  ),
  Product(
    name: 'Set Cangkir Teh Dinoyo',
    description: 'Set 4 cangkir dengan motif khas Dinoyo',
    category: 'Porselen',
  ),
  Product(
    name: 'Guci Dekoratif Besar',
    description: 'Guci dekorasi interior, tinggi 60cm, finishing glazur',
    category: 'Gerabah',
    price: 'Rp 450.000',
  ),
];

/// Katalog produk per toko (key = [Shop.id]).
const Map<String, List<Product>> shopProducts = {
  'sari-asih': [
    Product(
      name: 'Vas Bunga Ukir Klasik',
      description: 'Motif ukir bunga tradisional Jawa, tinggi 30cm',
      category: 'Semi-Porselen',
      price: 'Rp 150.000',
    ),
    Product(
      name: 'Guci Motif Batik Malangan',
      description: 'Guci semi-porselen dengan lukisan batik khas Malang',
      category: 'Semi-Porselen',
      price: 'Rp 275.000',
    ),
    Product(
      name: 'Paket Workshop Melukis Keramik',
      description: 'Sesi 2 jam melukis dan mengglasir keramik sendiri',
      category: 'Workshop',
      price: 'Rp 50.000',
    ),
  ],
  'galeri-porselen': [
    Product(
      name: 'Set Cangkir Teh Dinoyo',
      description: 'Set 4 cangkir porselen dengan motif khas Dinoyo',
      category: 'Porselen',
    ),
    Product(
      name: 'Piring Hias Lukis Tangan',
      description: 'Piring porselen pajangan dinding, dilukis tangan',
      category: 'Porselen',
      price: 'Rp 200.000',
    ),
    Product(
      name: 'Vas Porselen Putih Mini',
      description: 'Vas porselen tipis untuk hadiah dan koleksi',
      category: 'Porselen',
      price: 'Rp 95.000',
    ),
  ],
  'ibu-sri': [
    Product(
      name: 'Kendi Gerabah Tanah Liat',
      description: 'Kendi air tradisional dari tanah liat merah',
      category: 'Gerabah',
      price: 'Rp 35.000',
    ),
    Product(
      name: 'Pot Tanaman Gerabah',
      description: 'Pot gerabah untuk tanaman hias, berbagai ukuran',
      category: 'Gerabah',
      price: 'Rp 25.000',
    ),
    Product(
      name: 'Celengan Gerabah',
      description: 'Celengan bentuk hewan, cocok untuk anak-anak',
      category: 'Gerabah',
      price: 'Rp 15.000',
    ),
  ],
  'tiga-putra': [
    Product(
      name: 'Set Piring Makan Restoran',
      description: 'Piring semi-porselen tahan panas untuk restoran dan hotel',
      category: 'Semi-Porselen',
    ),
    Product(
      name: 'Mangkuk Saji Gerabah',
      description: 'Mangkuk saji gerabah untuk kafe dan rumah makan',
      category: 'Gerabah',
      price: 'Rp 30.000',
    ),
    Product(
      name: 'Cangkir Kopi Custom Logo',
      description: 'Cangkir kopi dengan cetak logo usaha, pesanan grosir',
      category: 'Semi-Porselen',
    ),
  ],
  'rumah-kriya': [
    Product(
      name: 'Lampu Meja Keramik',
      description: 'Lampu hias keramik berlubang untuk dekorasi interior',
      category: 'Keramik Hias',
      price: 'Rp 320.000',
    ),
    Product(
      name: 'Hiasan Dinding Relief',
      description: 'Panel relief keramik bermotif flora',
      category: 'Keramik Hias',
      price: 'Rp 180.000',
    ),
  ],
  'melati': [
    Product(
      name: 'Gantungan Kunci Keramik',
      description: 'Oleh-oleh mini bermotif ikon Kota Malang',
      category: 'Suvenir',
      price: 'Rp 5.000',
    ),
    Product(
      name: 'Magnet Kulkas Ikon Malang',
      description: 'Suvenir magnet keramik bergambar Tugu Malang',
      category: 'Suvenir',
      price: 'Rp 10.000',
    ),
    Product(
      name: 'Suvenir Pernikahan Vas Mini',
      description: 'Vas mini untuk suvenir pernikahan, minimal 100 pcs',
      category: 'Suvenir',
      price: 'Rp 7.500',
    ),
  ],
};

/// Katalog milik [shopId], atau katalog default bila belum diisi.
List<Product> productsOf(String shopId) =>
    shopProducts[shopId] ?? dummyProducts;

const List<HistoryEra> historyEras = [
  HistoryEra(
    chip: '1930-an',
    label: '1930-an',
    title: 'Awal Mula Produksi Gerabah',
    description:
        'Kampung Dinoyo mulai memproduksi gerabah sederhana sebagai mata pencaharian utama warga sekitar. Proses pembuatan masih sederhana, tetapi sudah menandai awal transformasi kawasan menjadi sentra kerajinan.',
    imageLabel: '[ Foto Arsip - Awal Produksi Gerabah ]',
  ),
  HistoryEra(
    chip: '1957',
    label: '1957',
    title: 'Proyek Percontohan Pemerintah',
    description:
        'Kawasan ditetapkan sebagai proyek percontohan, mendorong transisi ke produksi keramik semi-porselen. Langkah ini memperluas jangkauan pasar dan memperkaya kualitas karya pengrajin Dinoyo.',
    imageLabel: '[ Foto Arsip - Proyek Percontohan ]',
  ),
  HistoryEra(
    chip: 'Era Keemasan',
    label: 'Era Keemasan',
    title: 'Pengaruh Gaya Tiongkok',
    description:
        'Keramik Dinoyo menyerap pengaruh estetika Tiongkok, melahirkan motif dan teknik glasir khas. Perpaduan tradisi lokal dengan pengaruh luar membentuk identitas visual yang khas dan tahan lama.',
    imageLabel: '[ Foto Arsip - Pengaruh Gaya Tiongkok ]',
  ),
  HistoryEra(
    chip: 'Warisan Desain',
    label: 'Warisan Desain',
    title: 'Keramik Berpola Miring',
    description:
        'Desain unik yang dahulu disesuaikan dengan cara duduk perempuan - filosofi yang masih dijaga pengrajin. Motif miring khas Dinoyo menjadi salah satu penanda visual utama warisan keramik kawasan ini.',
    imageLabel: '[ Foto Arsip - Motif Miring Khas ]',
  ),
  HistoryEra(
    chip: 'Kini',
    label: 'Kini',
    title: 'Sentra Wisata Edukasi',
    description:
        'Kampung Dinoyo berkembang menjadi kawasan wisata edukasi dan direktori pengrajin keramik yang hidup. Pengunjung dapat menyusuri sejarah, melihat proses pembuatan, dan berinteraksi langsung dengan karya asli pengrajin.',
    imageLabel: '[ Foto Arsip - Sentra Wisata Edukasi ]',
  ),
];

/// Akun demo untuk layar Login. Ganti dengan data dari backend.
const List<AppAccount> dummyAccounts = [
  AppAccount(
    username: 'admin',
    email: 'admin@dinoyo.id',
    password: 'admin123',
    role: LoginRole.admin,
    displayName: 'Admin Paguyuban',
  ),
  AppAccount(
    username: 'sariasih',
    email: 'sariasih@dinoyo.id',
    password: 'pengrajin123',
    role: LoginRole.artisan,
    displayName: 'Toko Keramik Sari Asih',
    shopId: 'sari-asih',
  ),
];
