import '../../domain/entities/product.dart';
import '../../domain/entities/shop.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_local_datasource.dart';
import '../models/shop_model.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopLocalDataSource localDataSource;

  ShopRepositoryImpl(this.localDataSource);

  @override
  List<Shop> getShops() {
    return localDataSource.getShops().map((m) => m.toDomain()).toList();
  }

  @override
  Shop? getShopById(String id) {
    final list = getShops();
    try {
      return list.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void addShop(Shop shop) {
    localDataSource.addShop(ShopModel.fromDomain(shop));
  }

  @override
  void updateShop(Shop shop) {
    localDataSource.updateShop(ShopModel.fromDomain(shop));
  }

  @override
  void deleteShop(String id) {
    localDataSource.deleteShop(id);
  }

  @override
  List<Product> getProducts() {
    return localDataSource.getProducts().map((m) => m.toDomain()).toList();
  }

  @override
  List<Product> getProductsByShopId(String shopId) {
    return localDataSource
        .getProducts()
        .where((p) => p.shopId == shopId)
        .map((m) => m.toDomain())
        .toList();
  }
}
