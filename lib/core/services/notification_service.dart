import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InAppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  InAppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
      };

  factory InAppNotification.fromMap(Map<String, dynamic> map) =>
      InAppNotification(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
        isRead: map['isRead'] ?? false,
      );
}

class NotificationService {
  NotificationService(this._prefs);
  final SharedPreferences _prefs;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static const String _storageKey = 'in_app_notifications';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const linuxSettings = LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        linux: linuxSettings,
      );

      await _localNotifications.initialize(settings: initSettings);
      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService init fallback: $e');
      _isInitialized = true;
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // 1. Simpan ke in-app history
    final notif = InAppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    await _saveInAppNotification(notif);

    // 2. Tampilkan lewat platform notification jika memungkinkan
    try {
      const androidDetails = AndroidNotificationDetails(
        'dinoyo_channel',
        'Kampung Keramik Dinoyo',
        channelDescription: 'Notifikasi seputar Kampung Keramik Dinoyo',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );
      const iosDetails = DarwinNotificationDetails();
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        id: DateTime.now().millisecond,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('LocalNotification display skipped: $e');
    }
  }

  Future<void> _saveInAppNotification(InAppNotification notif) async {
    final list = getInAppNotifications();
    list.insert(0, notif);
    final jsonList = list.map((n) => jsonEncode(n.toMap())).toList();
    await _prefs.setStringList(_storageKey, jsonList);
  }

  List<InAppNotification> getInAppNotifications() {
    final raw = _prefs.getStringList(_storageKey) ?? [];
    return raw
        .map((item) {
          try {
            return InAppNotification.fromMap(jsonDecode(item));
          } catch (_) {
            return null;
          }
        })
        .whereType<InAppNotification>()
        .toList();
  }

  Future<void> markAllAsRead() async {
    final list = getInAppNotifications()
        .map((n) => InAppNotification(
              id: n.id,
              title: n.title,
              body: n.body,
              timestamp: n.timestamp,
              isRead: true,
            ))
        .toList();
    final jsonList = list.map((n) => jsonEncode(n.toMap())).toList();
    await _prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_storageKey);
  }
}
