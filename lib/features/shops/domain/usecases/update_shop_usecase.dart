import '../entities/shop.dart';
import '../repositories/shop_repository.dart';

class UpdateShop {
  final ShopRepository repository;
  UpdateShop(this.repository);

  void execute(Shop shop) {
    if (shop.name.trim().isEmpty) {
      throw ArgumentError('Nama toko wajib diisi');
    }
    repository.updateShop(shop);
  }
}
