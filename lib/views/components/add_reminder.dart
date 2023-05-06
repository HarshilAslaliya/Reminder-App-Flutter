import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reminder_app/controller/reminder_controller.dart';
import 'package:reminder_app/helpers/reminder_db_helper.dart';

import '../../helpers/notification_helper.dart';
import '../../modals/reminder.dart';

addReminder(context) {
  ReminderController reminderController = Get.find();

  final key = GlobalKey<FormState>();
  String title = "";
  String description = "";

  Get.bottomSheet(
    BottomSheet(
      enableDrag: true,
      onClosing: () {
        reminderController.clearTime();
      },
      builder: (context) => Container(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Add Reminder",
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        autofocus: true,
                        style: GoogleFonts.poppins(textStyle: TextStyle()),
                        decoration: textFiledDecoration(
                          label: "Title",
                          hint: "Enter Reminder title hear",
                        ),
                        validator: (val) =>
                            (val!.isEmpty) ? "Enter Title First" : null,
                        onSaved: (val) {
                          title = val!;
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              dateTimePicker(context, reminderController);
                            },
                            icon: const Icon(Icons.watch_later_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        style: GoogleFonts.poppins(textStyle: TextStyle()),
                        decoration: textFiledDecoration(
                          label: "Description",
                          hint: "Enter Description hear",
                        ),
                        validator: (val) =>
                            (val!.isEmpty) ? "Enter Description First" : null,
                        onSaved: (val) {
                          description = val!;
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => (reminderController.hour.value != 0)
                                ? Text(
                                    "${(reminderController.hour.value > 12) ? reminderController.hour.value - 12 : reminderController.hour.value}:${reminderController.minute.value} ${(reminderController.hour.value > 12) ? "PM" : "AM"}",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(fontSize: 16)),
                                  )
                                : const Text(""),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Center(
                  child: Transform.scale(
                    scale: 1.2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          key.currentState!.save();

                          if (reminderController.hour.value != 0) {
                            Reminder reminder = Reminder(
                                title: title,
                                description: description,
                                hour: reminderController.hour.value,
                                minute: reminderController.minute.value);
                            NotificationHelper.notificationHelper
                                .scheduleNotification(reminder: reminder);
                            ReminderDBHelper.reminderDBHelper
                                .insert(reminder: reminder);
                            reminderController.clearTime();
                            Get.back();
                          }
                        }
                      },
                      child: Text(
                        "Add",
                        style: GoogleFonts.poppins(textStyle: TextStyle()),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

dateTimePicker(context, reminderController) {
  showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  ).then((TimeOfDay? value1) {
    if (value1 != null) {
      reminderController.setTime(hourV: value1.hour, minuteV: value1.minute);
    }
  });
}

textFiledDecoration({required String label, required String hint}) {
  return InputDecoration(
    label: Text(label),
    contentPadding: const EdgeInsets.all(15),
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
