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
        'Deskripsi profil pengrajin: sejarah singkat toko, filosofi karya, dan keahlian khusus yang menjadi ciri khas. Bagian ini menampilkan kisah personal pengrajin agar pengunjung merasa terhubung sebelum menghubungi langsung via WhatsApp.',
  ),
  Shop(
    id: 'galeri-porselen',
    name: 'Galeri Porselen Dinoyo',
    specialty: 'Porselen Halus',
    address: 'Jl. MT Haryono IX No.45',
    hours: '09.00-17.00 WIB',
    workshop: WorkshopStatus.reservasi,
    categoryKeys: ['Semi-Porselen', 'Galeri Suvenir', 'Workshop Edukasi'],
  ),
  Shop(
    id: 'ibu-sri',
    name: 'Sanggar Gerabah Ibu Sri',
    specialty: 'Gerabah Tradisional',
    address: 'Jl. Dinoyo Gang III No.8',
    hours: '08.00-15.00 WIB',
    workshop: WorkshopStatus.tersedia,
    categoryKeys: ['Gerabah', 'Workshop Edukasi'],
  ),
  Shop(
    id: 'tiga-putra',
    name: 'Keramik Tiga Putra',
    specialty: 'Semi-Porselen & Gerabah',
    address: 'Jl. MT Haryono IX No.78',
    hours: '09.00-16.00 WIB',
    workshop: WorkshopStatus.tidakTersedia,
    categoryKeys: ['Semi-Porselen', 'Gerabah'],
  ),
  Shop(
    id: 'rumah-kriya',
    name: 'Rumah Kriya Keramik',
    specialty: 'Keramik Hias',
    address: 'Jl. Dinoyo Gang V No.3',
    hours: '10.00-17.00 WIB',
    workshop: WorkshopStatus.tersedia,
    categoryKeys: ['Galeri Suvenir', 'Workshop Edukasi'],
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
  ),
];

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
