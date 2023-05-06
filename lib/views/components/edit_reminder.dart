import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reminder_app/helpers/reminder_db_helper.dart';
import '../../controller/reminder_controller.dart';
import '../../helpers/notification_helper.dart';
import '../../modals/reminder.dart';
import 'add_reminder.dart';

editReminder(
    {required ReminderDB reminder, required BuildContext context}) async {
  ReminderController reminderController = Get.find();

  final key = GlobalKey<FormState>();
  String title = "";
  String description = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  reminderController.setTime(hourV: reminder.hour, minuteV: reminder.minute);
  titleController.text = reminder.title;
  descController.text = reminder.description;

  Get.dialog(
    AlertDialog(
      scrollable: true,
      title: Text(
        "Update Reminder",
        style: GoogleFonts.poppins(textStyle: TextStyle()),
      ),
      content: Form(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: titleController,
              style: GoogleFonts.poppins(textStyle: TextStyle()),
              decoration: textFiledDecoration(
                  label: "Title", hint: "Enter Reminder title hear"),
              validator: (val) => (val!.isEmpty) ? "Enter Title First" : null,
              onSaved: (val) {
                title = val!;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              style: GoogleFonts.poppins(textStyle: TextStyle()),
              controller: descController,
              decoration: textFiledDecoration(
                  label: "Description", hint: "Enter Description hear"),
              validator: (val) =>
                  (val!.isEmpty) ? "Enter Description First" : null,
              onSaved: (val) {
                description = val!;
              },
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    dateTimePickerEdit(context, reminderController);
                  },
                  icon: const Icon(Icons.watch_later_outlined),
                ),
                // Text("data"),
                Expanded(
                  child: Obx(
                    () => (reminderController.hour.value != 0)
                        ? Text(
                            "${(reminderController.hour.value > 12) ? reminderController.hour.value - 12 : reminderController.hour.value}:${reminderController.minute.value} ${(reminderController.hour.value > 12) ? "PM" : "AM"}",
                            style: GoogleFonts.poppins(textStyle: TextStyle()),
                          )
                        : const Text(""),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(textStyle: TextStyle()),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (key.currentState!.validate()) {
              key.currentState!.save();

              if (reminderController.hour.value != 0) {
                ReminderDB reminderDB = ReminderDB(
                    id: reminder.id,
                    title: title,
                    description: description,
                    hour: reminderController.hour.value,
                    minute: reminderController.minute.value);

                Reminder reminder2 = Reminder(
                    title: title,
                    description: description,
                    hour: reminderController.hour.value,
                    minute: reminderController.minute.value);

                NotificationHelper.notificationHelper
                    .scheduleNotification(reminder: reminder2);
                ReminderDBHelper.reminderDBHelper.update(reminder: reminderDB);
                reminderController.clearTime();
                Get.back();
              }
            }
          },
          child: Text(
            "Update",
            style: GoogleFonts.poppins(textStyle: TextStyle()),
          ),
        ),
      ],
    ),
  );
}

dateTimePickerEdit(context, ReminderController reminderController) {
  showTimePicker(
    context: context,
    initialTime: TimeOfDay(
        minute: reminderController.minute.value,
        hour: reminderController.hour.value),
  ).then((TimeOfDay? value1) {
    if (value1 != null) {
      reminderController.setTime(hourV: value1.hour, minuteV: value1.minute);
    }
  });
}
