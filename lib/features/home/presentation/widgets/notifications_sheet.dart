import 'package:flutter/material.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';

void showNotificationsSheet(
  BuildContext context,
  NotificationService notificationService,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _NotificationsSheet(notificationService: notificationService),
  );
}

class _NotificationsSheet extends StatefulWidget {
  final NotificationService notificationService;
  const _NotificationsSheet({required this.notificationService});

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  late List<InAppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _notifications = widget.notificationService.getInAppNotifications();
    setState(() {});
  }

  Future<void> _sendTestNotification(String title, String body) async {
    await widget.notificationService.showNotification(
      title: title,
      body: body,
    );
    _load();
    if (mounted) showToast(context, 'Notifikasi berhasil dikirim ke perangkat!');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
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
                child: const Icon(Icons.notifications_active_outlined,
                    size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pusat Notifikasi Perangkat', style: AppText.cardTitle),
                    Text('Notifikasi sistem lokal & pengingat kunjungan',
                        style: AppText.body12),
                  ],
                ),
              ),
              if (_notifications.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined,
                      size: 20, color: AppColors.brick),
                  tooltip: 'Hapus Semua',
                  onPressed: () async {
                    await widget.notificationService.clearAll();
                    _load();
                  },
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Quick trigger buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.waving_hand_outlined, size: 14),
                label: const Text('Kirim Sambutan', style: TextStyle(fontSize: 11)),
                backgroundColor: AppColors.white,
                onPressed: () => _sendTestNotification(
                  'Sugeng Rawuh di Dinoyo!',
                  'Selamat menjelajahi Kampung Wisata Keramik Dinoyo. Temukan 30+ pengrajin legendaris.',
                ),
              ),
              ActionChip(
                avatar: const Icon(Icons.palette_outlined, size: 14),
                label: const Text('Pengingat Workshop', style: TextStyle(fontSize: 11)),
                backgroundColor: AppColors.white,
                onPressed: () => _sendTestNotification(
                  'Jadwal Workshop Meja Putar',
                  'Workshop edukasi keramik dibuka setiap hari pukul 08.00 - 15.00 WIB.',
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          Expanded(
            child: _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.notifications_none,
                            size: 40, color: AppColors.muted),
                        const SizedBox(height: 8),
                        Text('Belum ada notifikasi.', style: AppText.body13),
                        const SizedBox(height: 4),
                        Text('Klik salah satu tombol di atas untuk menguji notifikasi.',
                            style: AppText.inter(size: 11, color: AppColors.muted)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.notifications_outlined,
                                size: 18, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.title,
                                      style: AppText.inter(
                                          size: 13, weight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text(n.body, style: AppText.body12),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${n.timestamp.hour.toString().padLeft(2, '0')}:${n.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: AppText.inter(
                                        size: 10, color: AppColors.muted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
