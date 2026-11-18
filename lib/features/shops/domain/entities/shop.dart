import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

enum WorkshopStatus { tersedia, reservasi, tidakTersedia }

extension WorkshopStatusX on WorkshopStatus {
  String get label => switch (this) {
        WorkshopStatus.tersedia => 'Workshop Tersedia',
        WorkshopStatus.reservasi => 'Workshop dengan Reservasi',
        WorkshopStatus.tidakTersedia => 'Workshop Tidak Tersedia',
      };

  String get shortLabel => switch (this) {
        WorkshopStatus.tersedia => 'Tersedia',
        WorkshopStatus.reservasi => 'dengan Reservasi',
        WorkshopStatus.tidakTersedia => 'Tidak Tersedia',
      };

  Color get background => switch (this) {
        WorkshopStatus.tersedia => AppColors.okBg,
        WorkshopStatus.reservasi => AppColors.warnBg,
        WorkshopStatus.tidakTersedia => AppColors.offBg,
      };

  Color get foreground => switch (this) {
        WorkshopStatus.tersedia => AppColors.okFg,
        WorkshopStatus.reservasi => AppColors.warnFg,
        WorkshopStatus.tidakTersedia => AppColors.offFg,
      };
}

class Shop {
  final String id;
  final String name;
  final String specialty;
  final String address;
  final String hours;
  final WorkshopStatus workshop;
  final List<String> categoryKeys;
  final String? established;
  final String about;
  final String whatsapp;
  final bool active;
  final String? imageAsset;

  const Shop({
    required this.id,
    required this.name,
    required this.specialty,
    required this.address,
    required this.hours,
    required this.workshop,
    this.categoryKeys = const [],
    this.established,
    this.about = '',
    this.whatsapp = '',
    this.active = true,
    this.imageAsset,
  });

  String get addressShort => address.split(' No.').first;

  Shop copyWith({
    String? name,
    String? specialty,
    String? address,
    String? hours,
    WorkshopStatus? workshop,
    List<String>? categoryKeys,
    String? established,
    String? about,
    String? whatsapp,
    bool? active,
    String? imageAsset,
  }) =>
      Shop(
        id: id,
        name: name ?? this.name,
        specialty: specialty ?? this.specialty,
        address: address ?? this.address,
        hours: hours ?? this.hours,
        workshop: workshop ?? this.workshop,
        categoryKeys: categoryKeys ?? this.categoryKeys,
        established: established ?? this.established,
        about: about ?? this.about,
        whatsapp: whatsapp ?? this.whatsapp,
        active: active ?? this.active,
        imageAsset: imageAsset ?? this.imageAsset,
      );
}
