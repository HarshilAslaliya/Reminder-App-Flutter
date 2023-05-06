import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:reminder_app/controller/reminder_controller.dart';
import 'package:reminder_app/controller/theme_controller.dart';
import 'package:reminder_app/helpers/reminder_db_helper.dart';
import '../../helpers/notification_helper.dart';
import '../components/add_reminder.dart';
import '../components/edit_reminder.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReminderThemeController themeController = Get.put(ReminderThemeController());

  ReminderController reminderController = Get.put(ReminderController());

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/launcher_icon');
    var initializationSettingsIOs = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    NotificationHelper.flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Container(),
        title: Text(
          "Reminder",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          )),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                themeController.changeTheme();
              },
              icon: Icon((themeController.darkTheme.value)
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addReminder(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => GridView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(10),
          itemCount: reminderController.reminders.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, i) {
            var e = reminderController.reminders;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Container(
                            width:75,
                            child: Text(
                              e[i].title,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18)),
                            ),
                          ),
                          Text(
                              "${(e[i].hour > 12) ? e[i].hour - 12 : e[i].hour}:${e[i].minute}  ${(e[i].hour > 12) ? "PM" : "AM"}",
                              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16,))),
                        ],
                      ),
                    ),
                    Divider(endIndent: 15, indent: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("${e[i].description}",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18,)),),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            editReminder(reminder: e[i], context: context);
                          },
                          icon: const Icon(Icons.edit_rounded),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Delete Reminder"),
                                content: const Text(
                                  "Are you sure want to Delete?",
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ReminderDBHelper.reminderDBHelper
                                          .delete(id: e[i].id);
                                      Get.back();
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),),
    );
  }
}
