import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/shop.dart';
import '../../domain/usecases/add_shop_usecase.dart';
import '../../domain/usecases/delete_shop_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_shops_usecase.dart';
import '../../domain/usecases/update_shop_usecase.dart';

class ShopViewModel extends ChangeNotifier {
  final GetShops getShops;
  final AddShop addShopUseCase;
  final UpdateShop updateShopUseCase;
  final DeleteShop deleteShopUseCase;
  final GetProducts getProducts;

  ShopViewModel({
    required this.getShops,
    required this.addShopUseCase,
    required this.updateShopUseCase,
    required this.deleteShopUseCase,
    required this.getProducts,
  });

  String _searchQuery = '';
  String _selectedCategory = 'Semua Kategori';
  WorkshopStatus? _workshopFilter;
  bool? _activeFilter;
  bool _ascending = true;
  String? _errorMessage;

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  WorkshopStatus? get workshopFilter => _workshopFilter;
  bool? get activeFilter => _activeFilter;
  bool get ascending => _ascending;
  String? get errorMessage => _errorMessage;

  List<Shop> get allShops => getShops.execute();
  List<Product> get allProducts => getProducts.execute();

  List<Shop> get filteredShops {
    final q = _searchQuery.trim().toLowerCase();
    final list = allShops.where((s) {
      final matchCategory = _selectedCategory == 'Semua Kategori' ||
          s.categoryKeys.contains(_selectedCategory);
      final matchWorkshop =
          _workshopFilter == null || s.workshop == _workshopFilter;
      final matchActive = _activeFilter == null || s.active == _activeFilter;
      final matchQuery = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.specialty.toLowerCase().contains(q) ||
          s.address.toLowerCase().contains(q);

      return matchCategory && matchWorkshop && matchActive && matchQuery;
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return _ascending ? list : list.reversed.toList();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setWorkshopFilter(WorkshopStatus? status) {
    _workshopFilter = status;
    notifyListeners();
  }

  void setActiveFilter(bool? active) {
    _activeFilter = active;
    notifyListeners();
  }

  void toggleSort() {
    _ascending = !_ascending;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'Semua Kategori';
    _workshopFilter = null;
    _activeFilter = null;
    notifyListeners();
  }

  void addShop(Shop shop) {
    try {
      addShopUseCase.execute(shop);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void updateShop(Shop shop) {
    try {
      updateShopUseCase.execute(shop);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void deleteShop(String id) {
    try {
      deleteShopUseCase.execute(id);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
