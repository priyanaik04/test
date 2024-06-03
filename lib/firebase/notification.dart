import "dart:convert";
import "package:chatapp/firebase_options.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:http/http.dart" as http;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationAPI {
  static final _noti = FlutterLocalNotificationsPlugin();

  static NotificationDetails? get notificationDetails =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "id",
          "name",
          channelDescription: 'desc',
          importance: Importance.max,
        ),
      );

  static Future postLocalNotification({
    int id = 0,
    required String title,
    required String message,
    String? image,
  }) async {
    _noti.show(id, title, message, notificationDetails, payload: "chat_screen");
  }

  static Future postNotification({
    int id = 0,
    bool event = false,
    required String title,
    required String message,
    required String receiver,
  }) async {
    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=${DefaultFirebaseOptions.messagingKey}",
        },
        body: jsonEncode(
          <String, dynamic>{
            "notification": <String, dynamic>{
              "body": message,
              "title": title,
            },
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "event": event,
              "status": "done",
              "route": "chat_screen"
            },
            "to": receiver,
          },
        ));
  }
}
