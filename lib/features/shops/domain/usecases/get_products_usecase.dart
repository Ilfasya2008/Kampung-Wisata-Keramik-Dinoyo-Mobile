import '../entities/product.dart';
import '../repositories/shop_repository.dart';

class GetProducts {
  final ShopRepository repository;
  GetProducts(this.repository);

  List<Product> execute({String? shopId}) {
    if (shopId != null && shopId.isNotEmpty) {
      return repository.getProductsByShopId(shopId);
    }
    return repository.getProducts();
  }
}
