import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/loyalty_card.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> scheduleExpiryNotification(LoyaltyCard card) async {
    // Schedule notification 7 days before expiry
    final notificationDate = card.expiryDate.subtract(const Duration(days: 7));

    if (notificationDate.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        card.id!,
        'Card Expiring Soon',
        'Your ${card.name} card will expire in 7 days',
        tz.TZDateTime.from(notificationDate, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'card_expiry_channel',
            'Card Expiry Notifications',
            channelDescription: 'Notifications for expiring loyalty cards',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelExpiryNotification(int cardId) async {
    await _notifications.cancel(cardId);
  }

  Future<void> showRewardNotification(String title, String body) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'rewards_channel',
          'Rewards Notifications',
          channelDescription: 'Notifications for loyalty card rewards',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> checkAndScheduleNotifications(List<LoyaltyCard> cards) async {
    for (final card in cards) {
      await scheduleExpiryNotification(card);
    }
  }
}
