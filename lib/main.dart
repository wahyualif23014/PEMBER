import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:absolute_cinema/services/auth_service.dart';
import 'package:absolute_cinema/screens/tab_navigation_screen.dart';
import 'package:absolute_cinema/screens/auth/login_screen.dart';
import 'package:absolute_cinema/screens/auth/register_screen.dart';
import 'package:absolute_cinema/screens/auth/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'services/notification_controller.dart';
import 'package:absolute_cinema/widgets/connection_status_widget.dart';
import 'package:absolute_cinema/services/ConnectionService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    'resource://mipmap/ic_launcher', // icon aplikasi
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
    debug: true,
  );

  //  listener event notifikasi
  AwesomeNotifications().setListeners(
    onNotificationCreatedMethod:
        NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod:
        NotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod:
        NotificationController.onDismissActionReceivedMethod,
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  );

  // Minta izin notifikasi jika belum diberikan
  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absolute Cinema',
      theme: ThemeData.dark(),
      initialRoute: '/TabNavigationScreen',
      getPages: [
        GetPage(name: '/', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const TabNavigationScreen()),
      ],
      home: FutureBuilder<bool>(
        future: ConnectionService.checkConnection(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            );
          }

          if (!snapshot.data!) {
            return ConnectionStatusWidget(
              onConnected:
                  () =>
                      Get.forceAppUpdate(), // refresh app saat koneksi kembali
            );
          }

          return StreamBuilder<User?>(
            stream: authService.value.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: Colors.amberAccent),
                  ),
                );
              }

              if (snapshot.hasData) {
                Future.microtask(() {
                  if (Get.currentRoute != '/home') {
                    Get.offAllNamed('/home');
                  }
                });
                return const SizedBox();
              } else {
                return const WelcomeScreen();
              }
            },
          );
        },
      ),
    );
  }
}
