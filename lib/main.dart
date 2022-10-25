import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/theme/light_theme.dart';
import 'package:knaw_news/view/screens/inbox/inbox.dart';
import 'package:knaw_news/view/screens/splash/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppData.initiate();
  await OneSignal.shared.setAppId("e4d5b9b9-1f98-4c75-9544-3b3baf5d395c");
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    AppData().isAuthenticated ? Get.to(const InboxScreen()) : null;
  });
  OneSignal.shared.promptUserForPushNotificationPermission();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
      theme: light,
      home: const SplashScreen(),
    );
  }
}
