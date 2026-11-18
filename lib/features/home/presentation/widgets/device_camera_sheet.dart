import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';
import '../../../../widgets/common.dart';

void showDeviceCameraSheet(
  BuildContext context,
  NotificationService notificationService,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _CameraSheet(notificationService: notificationService),
  );
}

class _CameraSheet extends StatefulWidget {
  final NotificationService notificationService;
  const _CameraSheet({required this.notificationService});

  @override
  State<_CameraSheet> createState() => _CameraSheetState();
}

class _CameraSheetState extends State<_CameraSheet> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isProcessing = false;

  Future<void> _pick(ImageSource source) async {
    setState(() => _isProcessing = true);
    try {
      final img = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (img != null) {
        setState(() => _selectedImage = img);
      }
    } catch (e) {
      if (mounted) showToast(context, 'Tidak dapat mengakses perangkat: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _savePhoto() async {
    if (_selectedImage == null) return;
    Navigator.of(context).pop();

    await widget.notificationService.showNotification(
      title: 'Karya Keramik Anda Disimpan!',
      body:
          'Foto kerajinan workshop telah berhasil didokumentasikan di galeri perangkat Anda.',
    );
    if (mounted) {
      showToast(context, 'Foto karya berhasil disimpan & notifikasi dikirim.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.tan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dokumentasi Karya Workshop', style: AppText.cardTitle),
                      Text('Ambil foto via Kamera Perangkat atau Galeri',
                          style: AppText.body12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: kIsWeb
                      ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                      : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Ambil Ulang',
                      variant: AppButtonVariant.outline,
                      onPressed: () => setState(() => _selectedImage = null),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Simpan Karya',
                      icon: Icons.check,
                      onPressed: _savePhoto,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: _isProcessing ? 'Membuka...' : 'Kamera Perangkat',
                      icon: Icons.photo_camera,
                      minHeight: 50,
                      onPressed: _isProcessing ? null : () => _pick(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: _isProcessing ? 'Membuka...' : 'Pilih dari Galeri',
                      variant: AppButtonVariant.outline,
                      icon: Icons.photo_library_outlined,
                      minHeight: 50,
                      onPressed: _isProcessing ? null : () => _pick(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
