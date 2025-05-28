import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    print("✅ Notification Created: ${receivedNotification.title}");
  }

  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    print("✅ Notification Displayed: ${receivedNotification.title}");
  }

  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    print("🗑️ Notification Dismissed");
  }

  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    print("📲 Notification Clicked: ${receivedAction.buttonKeyPressed}");
  }
}
