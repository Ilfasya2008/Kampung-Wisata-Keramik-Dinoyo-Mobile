import '../repositories/shop_repository.dart';

class DeleteShop {
  final ShopRepository repository;
  DeleteShop(this.repository);

  void execute(String id) {
    repository.deleteShop(id);
  }
}
