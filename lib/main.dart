import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/Reminder/home.dart';
import 'package:reminder_app/Reminder/services.dart';

import 'Constants/theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService notificationService = NotificationService();
  await notificationService.initReminder();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (
            context,
            ModelTheme themeNotifier,
            child,
            ) {
          return MaterialApp(
            theme: themeNotifier.isDark
                ? ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
            )
                : ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.black,
            ),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
