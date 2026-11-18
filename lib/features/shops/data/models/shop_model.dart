import '../../domain/entities/shop.dart';

class ShopModel extends Shop {
  const ShopModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.address,
    required super.hours,
    required super.workshop,
    super.categoryKeys,
    super.established,
    super.about,
    super.whatsapp,
    super.active,
    super.imageAsset,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'address': address,
        'hours': hours,
        'workshop': workshop.name,
        'categoryKeys': categoryKeys,
        'established': established,
        'about': about,
        'whatsapp': whatsapp,
        'active': active,
        'imageAsset': imageAsset,
      };

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    WorkshopStatus parseWorkshop(String? val) {
      return WorkshopStatus.values.firstWhere(
        (e) => e.name == val,
        orElse: () => WorkshopStatus.tersedia,
      );
    }

    return ShopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      address: json['address'] ?? '',
      hours: json['hours'] ?? '08.00 - 16.00 WIB',
      workshop: parseWorkshop(json['workshop']),
      categoryKeys: (json['categoryKeys'] as List?)?.map((e) => e.toString()).toList() ?? [],
      established: json['established'],
      about: json['about'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      active: json['active'] ?? true,
      imageAsset: json['imageAsset'],
    );
  }

  Shop toDomain() => Shop(
        id: id,
        name: name,
        specialty: specialty,
        address: address,
        hours: hours,
        workshop: workshop,
        categoryKeys: categoryKeys,
        established: established,
        about: about,
        whatsapp: whatsapp,
        active: active,
        imageAsset: imageAsset,
      );

  factory ShopModel.fromDomain(Shop s) => ShopModel(
        id: s.id,
        name: s.name,
        specialty: s.specialty,
        address: s.address,
        hours: s.hours,
        workshop: s.workshop,
        categoryKeys: s.categoryKeys,
        established: s.established,
        about: s.about,
        whatsapp: s.whatsapp,
        active: s.active,
        imageAsset: s.imageAsset,
      );
}
