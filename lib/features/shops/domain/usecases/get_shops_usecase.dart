import '../entities/shop.dart';
import '../repositories/shop_repository.dart';

class GetShops {
  final ShopRepository repository;
  GetShops(this.repository);

  List<Shop> execute() => repository.getShops();
}
