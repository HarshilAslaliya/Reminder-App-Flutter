import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_app/helpers/reminder_db_helper.dart';
import 'package:reminder_app/views/screens/homepage.dart';
import 'package:reminder_app/views/screens/splashpage.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  ReminderDBHelper.reminderDBHelper.fetchRecords();
  runApp(MyApp(),);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      getPages: [
        GetPage(name: "/", page: () => const HomePage()),
        GetPage(name: "/splash", page: () => const SplashPage()),
      ],
    );
  }
}
