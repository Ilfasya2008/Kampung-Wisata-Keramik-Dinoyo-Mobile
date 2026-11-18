import '../entities/product.dart';
import '../entities/shop.dart';

abstract class ShopRepository {
  List<Shop> getShops();
  Shop? getShopById(String id);
  void addShop(Shop shop);
  void updateShop(Shop shop);
  void deleteShop(String id);
  List<Product> getProducts();
  List<Product> getProductsByShopId(String shopId);
}
