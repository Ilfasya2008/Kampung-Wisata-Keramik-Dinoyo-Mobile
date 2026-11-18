import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/shop.dart';
import '../models/product_model.dart';
import '../models/shop_model.dart';

abstract class ShopLocalDataSource {
  List<ShopModel> getShops();
  void addShop(ShopModel shop);
  void updateShop(ShopModel shop);
  void deleteShop(String id);
  List<ProductModel> getProducts();
}

class ShopLocalDataSourceImpl implements ShopLocalDataSource {
  final SharedPreferences prefs;
  static const String _shopsStorageKey = 'dinoyo_shops_data_list';

  late List<ShopModel> _cachedShops;
  late final List<ProductModel> _cachedProducts;

  ShopLocalDataSourceImpl(this.prefs) {
    _initProducts();
    _initShops();
  }

  void _initProducts() {
    _cachedProducts = [
      const ProductModel(
        id: 'prod_01',
        name: 'Vas Bunga Ukir Klasik Dinoyo',
        description: 'Motif ukir flora tradisional Jawa, finishing glasir putih halus semi-porselen tinggi 30 cm.',
        category: 'Semi-Porselen',
        price: 'Rp 150.000',
        imageAsset: 'assets/images/product_vas_bunga.jpg',
        shopId: 'sari-asih',
      ),
      const ProductModel(
        id: 'prod_02',
        name: 'Set Cangkir Teh Porselen Dinoyo',
        description: 'Set 4 cangkir + 1 poci dengan aksen motif miring khas Dinoyo, tahan panas dan food-grade.',
        category: 'Porselen Halus',
        price: 'Rp 220.000',
        imageAsset: 'assets/images/product_set_cangkir.jpg',
        shopId: 'galeri-porselen',
      ),
      const ProductModel(
        id: 'prod_03',
        name: 'Guci Dekoratif Besar Celadon',
        description: 'Guci dekorasi interior ruang tamu, tinggi 60 cm, finishing glasir crackle hijau celadon elegan.',
        category: 'Gerabah',
        price: 'Rp 450.000',
        imageAsset: 'assets/images/product_guci_dekoratif.jpg',
        shopId: 'ibu-sri',
      ),
      const ProductModel(
        id: 'prod_04',
        name: 'Teko Poci Keramik Tradisional',
        description: 'Poci minum teh tanah liat pembakaran biskuit 900°C menghasilkan aroma teh melati khas.',
        category: 'Gerabah',
        price: 'Rp 95.000',
        imageAsset: 'assets/images/product_teko_poci.jpg',
        shopId: 'tiga-putra',
      ),
      const ProductModel(
        id: 'prod_05',
        name: 'Celengan Karakter Keramik Lucu',
        description: 'Suvenir celengan karakter hewan keramik Dinoyo, cat enamel warna-warni ramah anak.',
        category: 'Galeri Suvenir',
        price: 'Rp 35.000',
        imageAsset: 'assets/images/product_celengan.jpg',
        shopId: 'melati',
      ),
      const ProductModel(
        id: 'prod_06',
        name: 'Asbak & Tempat Dupa Relief Candi',
        description: 'Asbak kriya dengan ukiran relief Candi Kanjuruhan & motif batik khas Malang.',
        category: 'Keramik Hias',
        price: 'Rp 55.000',
        imageAsset: 'assets/images/product_asbak_relief.jpg',
        shopId: 'rumah-kriya',
      ),
    ];
  }

  void _initShops() {
    final raw = prefs.getStringList(_shopsStorageKey);
    if (raw != null && raw.isNotEmpty) {
      _cachedShops = raw
          .map((str) {
            try {
              return ShopModel.fromJson(jsonDecode(str));
            } catch (_) {
              return null;
            }
          })
          .whereType<ShopModel>()
          .toList();
    } else {
      _cachedShops = [
        const ShopModel(
          id: 'sari-asih',
          name: 'Toko Keramik Sari Asih',
          specialty: 'Semi-Porselen',
          address: 'Jl. MT Haryono IX No.12',
          hours: '08.00-16.00 WIB',
          workshop: WorkshopStatus.tersedia,
          categoryKeys: ['Semi-Porselen', 'Workshop Edukasi'],
          established: '1962',
          about:
              'Toko Keramik Sari Asih adalah salah satu pelopor usaha keramik rumahan setelah masa pabrik percontohan 1957. Menyediakan aneka vas bunga, guci, dan paket workshop teknik putar bagi rombongan sekolah.',
          whatsapp: '6281234567890',
          imageAsset: 'assets/images/product_vas_bunga.jpg',
        ),
        const ShopModel(
          id: 'galeri-porselen',
          name: 'Galeri Porselen Dinoyo',
          specialty: 'Porselen Halus',
          address: 'Jl. MT Haryono IX No.45',
          hours: '09.00-17.00 WIB',
          workshop: WorkshopStatus.reservasi,
          categoryKeys: ['Semi-Porselen', 'Galeri Suvenir', 'Workshop Edukasi', 'Porselen Halus'],
          established: '1975',
          about:
              'Menyajikan koleksi porselen glasir ganda berkualitas tinggi untuk kebutuhan tableware restoran, kafe, dan dekorasi mewah dengan teknik pembakaran 1.200°C.',
          whatsapp: '6281234567891',
          imageAsset: 'assets/images/product_set_cangkir.jpg',
        ),
        const ShopModel(
          id: 'ibu-sri',
          name: 'Sanggar Gerabah Ibu Sri',
          specialty: 'Gerabah Tradisional',
          address: 'Jl. Dinoyo Gang III No.8',
          hours: '08.00-15.00 WIB',
          workshop: WorkshopStatus.tersedia,
          categoryKeys: ['Gerabah', 'Workshop Edukasi'],
          established: '1958',
          about:
              'Sanggar yang melestarikan teknik gerabah putar manual warisan keluarga secara turun temurun. Tempat paling otentik untuk belajar dasar memilin tanah liat.',
          whatsapp: '6281234567892',
          imageAsset: 'assets/images/product_guci_dekoratif.jpg',
        ),
        const ShopModel(
          id: 'tiga-putra',
          name: 'Keramik Tiga Putra',
          specialty: 'Semi-Porselen & Gerabah',
          address: 'Jl. MT Haryono IX No.78',
          hours: '09.00-16.00 WIB',
          workshop: WorkshopStatus.tidakTersedia,
          categoryKeys: ['Semi-Porselen', 'Gerabah'],
          established: '1984',
          about:
              'Pusat produksi poci teh, mangkuk saji, dan peralatan rumah tangga tanah liat berkualitas ekspor.',
          whatsapp: '6281234567893',
          imageAsset: 'assets/images/product_teko_poci.jpg',
        ),
        const ShopModel(
          id: 'rumah-kriya',
          name: 'Rumah Kriya Keramik',
          specialty: 'Keramik Hias',
          address: 'Jl. Dinoyo Gang V No.3',
          hours: '10.00-17.00 WIB',
          workshop: WorkshopStatus.tersedia,
          categoryKeys: ['Galeri Suvenir', 'Workshop Edukasi', 'Keramik Hias'],
          established: '1995',
          about:
              'Fokus pada keramik cinderamata modern, plakat, relief candi, dan souvenir custom pesta pernikahan.',
          whatsapp: '6281234567894',
          imageAsset: 'assets/images/product_asbak_relief.jpg',
        ),
        const ShopModel(
          id: 'melati',
          name: 'Toko Suvenir Melati',
          specialty: 'Suvenir Keramik',
          address: 'Jl. MT Haryono IX No.90',
          hours: '08.00-18.00 WIB',
          workshop: WorkshopStatus.tidakTersedia,
          categoryKeys: ['Galeri Suvenir'],
          established: '1999',
          about:
              'Menjual eceran dan grosir souvenir celengan karakter, asbak unik, dan cinderamata khas oleh-oleh Kota Malang.',
          whatsapp: '6281234567895',
          imageAsset: 'assets/images/product_celengan.jpg',
        ),
      ];
      _saveShopsToPrefs();
    }
  }

  void _saveShopsToPrefs() {
    final list = _cachedShops.map((s) => jsonEncode(s.toJson())).toList();
    prefs.setStringList(_shopsStorageKey, list);
  }

  @override
  List<ShopModel> getShops() => List.unmodifiable(_cachedShops);

  @override
  void addShop(ShopModel shop) {
    _cachedShops.insert(0, shop);
    _saveShopsToPrefs();
  }

  @override
  void updateShop(ShopModel shop) {
    final index = _cachedShops.indexWhere((s) => s.id == shop.id);
    if (index != -1) {
      _cachedShops[index] = shop;
      _saveShopsToPrefs();
    }
  }

  @override
  void deleteShop(String id) {
    _cachedShops.removeWhere((s) => s.id == id);
    _saveShopsToPrefs();
  }

  @override
  List<ProductModel> getProducts() => List.unmodifiable(_cachedProducts);
}
