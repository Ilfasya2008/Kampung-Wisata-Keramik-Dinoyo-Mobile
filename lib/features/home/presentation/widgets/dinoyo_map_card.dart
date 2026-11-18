import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/location_service.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';
import '../../../../widgets/common.dart';

class DinoyoMapCard extends StatefulWidget {
  const DinoyoMapCard({super.key});

  @override
  State<DinoyoMapCard> createState() => _DinoyoMapCardState();
}

class _DinoyoMapCardState extends State<DinoyoMapCard> {
  final LocationService _locationService = LocationService();
  bool _isCheckingDistance = false;
  String? _distanceInfo;

  Future<void> _checkDistance() async {
    setState(() => _isCheckingDistance = true);
    final result = await _locationService.calculateDistanceToDinoyo();
    if (mounted) {
      setState(() {
        _isCheckingDistance = false;
        if (result.isSuccess) {
          _distanceInfo = 'Jarak Anda ke Dinoyo: ${result.formattedDistance}';
        } else {
          _distanceInfo = result.statusMessage;
        }
      });
      showToast(context, result.statusMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/map_dinoyo.jpg',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ImagePlaceholder(
                  label: '[ Peta Lokasi Kampung Wisata Keramik Dinoyo ]',
                  height: 180,
                  icon: Icons.map_outlined,
                  radius: 0,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.place, size: 14, color: AppColors.background),
                      const SizedBox(width: 4),
                      Text('Google Maps Terintegrasi',
                          style: AppText.inter(
                              size: 11,
                              weight: FontWeight.w700,
                              color: AppColors.background)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kampung Wisata Keramik Dinoyo', style: AppText.cardTitle),
                const SizedBox(height: 4),
                Text(AppConstants.dinoyoAddress, style: AppText.body12),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.my_location,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('Koordinat: -7.942721, 112.607425',
                        style: AppText.inter(size: 11, color: AppColors.muted)),
                  ],
                ),
                if (_distanceInfo != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.tan,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.navigation,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_distanceInfo!,
                              style: AppText.inter(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.ink)),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: _isCheckingDistance
                            ? 'Mendeteksi GPS...'
                            : 'Cek Jarak (GPS)',
                        icon: Icons.gps_fixed,
                        variant: AppButtonVariant.outline,
                        fontSize: 12,
                        minHeight: 46,
                        onPressed: _isCheckingDistance ? null : _checkDistance,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        label: 'Buka di Maps',
                        icon: Icons.map_outlined,
                        fontSize: 12,
                        minHeight: 46,
                        onPressed: () => openMaps(context, AppConstants.dinoyoAddress),
                      ),
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
