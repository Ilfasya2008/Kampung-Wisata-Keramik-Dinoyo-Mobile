import 'package:flutter/material.dart';

import '../data/models.dart';
import '../screens/shop_profile_screen.dart';
import '../theme/app_theme.dart';
import '../utils/launcher.dart';
import 'common.dart';

void openShopProfile(BuildContext context, Shop shop) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ShopProfileScreen(shop: shop)),
  );
}

/// Full-width card used on the Direktori list (screen 02).
class ShopListCard extends StatelessWidget {
  const ShopListCard({super.key, required this.shop});
  final Shop shop;

  Widget _meta(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 13, color: AppColors.muted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body12),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ImagePlaceholder(
                label: '[ Foto Toko ]',
                width: 104,
                height: 112,
                radius: 14,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: AppText.cardTitle),
                    const SizedBox(height: 6),
                    _meta(Icons.sell_outlined, shop.specialty),
                    const SizedBox(height: 4),
                    _meta(Icons.place_outlined, shop.address),
                    const SizedBox(height: 4),
                    _meta(Icons.schedule, shop.hours),
                    const SizedBox(height: 8),
                    WorkshopChip(shop.workshop),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Lihat Profil Toko',
                  trailingIcon: Icons.arrow_forward,
                  onPressed: () => openShopProfile(context, shop),
                ),
              ),
              const SizedBox(width: 8),
              WhatsAppIconButton(
                onPressed: () => openWhatsApp(
                  context,
                  phone: shop.whatsapp,
                  message: 'Halo ${shop.name}, saya ingin bertanya.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 250px wide card used in the horizontal "Direktori" preview on Beranda.
class ShopPreviewCard extends StatelessWidget {
  const ShopPreviewCard({super.key, required this.shop});
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ImagePlaceholder(
            label: '[ Foto Toko / Workshop ]',
            height: 130,
            radius: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop.name, style: AppText.cardTitle),
                const SizedBox(height: 6),
                Text(
                  'Spesialis ${shop.specialty.toLowerCase()}'
                  '${shop.established != null ? ', est. ${shop.established}' : ''}',
                  style: AppText.body12,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Lihat Profil',
                        variant: AppButtonVariant.outline,
                        fontSize: 12,
                        onPressed: () => openShopProfile(context, shop),
                      ),
                    ),
                    const SizedBox(width: 8),
                    WhatsAppIconButton(
                      onPressed: () => openWhatsApp(context, phone: shop.whatsapp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
