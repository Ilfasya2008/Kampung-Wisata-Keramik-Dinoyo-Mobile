import '../entities/shop.dart';
import '../repositories/shop_repository.dart';

class AddShop {
  final ShopRepository repository;
  AddShop(this.repository);

  void execute(Shop shop) {
    if (shop.name.trim().isEmpty) {
      throw ArgumentError('Nama toko wajib diisi');
    }
    if (shop.address.trim().isEmpty) {
      throw ArgumentError('Alamat toko wajib diisi');
    }
    repository.addShop(shop);
  }
}
