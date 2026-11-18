import 'package:flutter/material.dart';
import '../features/shops/domain/entities/shop.dart';
import '../features/shops/presentation/views/shop_profile_screen.dart';
import '../features/shops/presentation/viewmodels/shop_viewmodel.dart';
import '../theme/app_theme.dart';
import '../utils/launcher.dart';
import 'common.dart';

void openShopProfile(BuildContext context, Shop shop, ShopViewModel shopViewModel) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ShopProfileScreen(
        shop: shop,
        shopViewModel: shopViewModel,
      ),
    ),
  );
}

class ShopListCard extends StatelessWidget {
  final Shop shop;
  final ShopViewModel? viewModel;
  const ShopListCard({super.key, required this.shop, this.viewModel});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  shop.imageAsset ?? 'assets/images/product_vas_bunga.jpg',
                  width: 104,
                  height: 112,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ImagePlaceholder(
                    label: '[ Foto Toko ]',
                    width: 104,
                    height: 112,
                    radius: 14,
                  ),
                ),
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
                  onPressed: () {
                    if (viewModel != null) {
                      openShopProfile(context, shop, viewModel!);
                    } else {
                      Navigator.of(context).pushNamed('/profile_shop', arguments: shop);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              WhatsAppIconButton(
                onPressed: () => openWhatsApp(
                  context,
                  phone: shop.whatsapp,
                  message: 'Halo ${shop.name}, saya ingin bertanya seputar keramik.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShopPreviewCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback? onTap;
  const ShopPreviewCard({super.key, required this.shop, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            shop.imageAsset ?? 'assets/images/hero_dinoyo.jpg',
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ImagePlaceholder(
              label: '[ Foto Toko / Workshop ]',
              height: 130,
              radius: 0,
            ),
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
                        onPressed: onTap,
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
