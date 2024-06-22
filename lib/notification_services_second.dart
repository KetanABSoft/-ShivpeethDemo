
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backGroundMessage(RemoteMessage message) async
{
  print("############Firebase Background Notification");

}
class NotificationService
{
static Future<void> inilialize() async
{
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
  if(settings.authorizationStatus == AuthorizationStatus.authorized)
    {
      FirebaseMessaging.onBackgroundMessage((backGroundMessage));
      print(" ########Firebase Notification Initialized");
    }
}
}