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
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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

  await supa.Supabase.initialize(
    url: 'https://ifnrnryhiqskyhcjaqvo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmbnJucnloaXFza3loY2phcXZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxNTk0NjQsImV4cCI6MjA2MzczNTQ2NH0.YEGW2-wru3n2uESapbM6XcyXss3_VghU8FavReWCFg0',
  );
  // Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

// add mob
class InterstitialExample extends StatefulWidget {
  @override
  InterstitialExampleState createState() => InterstitialExampleState();
}

class InterstitialExampleState extends State<InterstitialExample> {
  InterstitialAd? _interstitialAd;

  final adUnitId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/1033173712'
    : 'ca-app-pub-3940256099942544/4411468910';

  void loadAd() {
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Interstitial Example'),
      ),
    );
  }
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
              onConnected: () => Get.forceAppUpdate(),
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
