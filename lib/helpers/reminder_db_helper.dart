import 'package:reminder_app/controller/reminder_controller.dart';
import 'package:reminder_app/modals/reminder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

ReminderController reminderController = Get.put(
  ReminderController(),
);

class ReminderDBHelper {
  ReminderDBHelper._();

  static final ReminderDBHelper reminderDBHelper = ReminderDBHelper._();

  final String dbName = "reminder.db";
  final String tableName = "reminder";
  final String colId = "id";
  final String colTitle = "title";
  final String colDes = "description";
  final String colHours = "hours";
  final String colMinutes = "minutes";

  Database? db;

  initDb() async {
    String directory = await getDatabasesPath();
    String path = join(directory, dbName);

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {},
    );

    await db?.execute(
        "CREATE TABLE IF NOT EXISTS $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDes TEXT, $colHours INTEGER, $colMinutes INTEGER);");
  }

  insert({required Reminder reminder}) async {
    await initDb();
    String query =
        "INSERT INTO $tableName($colTitle, $colDes, $colHours, $colMinutes) VALUES(?, ?, ?, ?);";
    List args = [
      reminder.title,
      reminder.description,
      reminder.hour,
      reminder.minute,
    ];
    await db?.rawInsert(query, args);
    fetchRecords();
  }

  fetchRecords() async {
    await initDb();

    String query = "SELECT * FROM $tableName";

    List<Map<String, dynamic>> data = await db!.rawQuery(query);

    List<ReminderDB> reminderList =
        data.map((e) => ReminderDB.fromData(data: e)).toList();

    reminderController.reminders.value = reminderList;

    reminderController.reminders.value.sort((a, b) {
      int minute = (a.minute > 9) ? a.minute : int.parse("0${a.minute}");
      int minute2 = (a.minute > 9) ? a.minute : int.parse("0${b.minute}");

      return (int.parse("${a.hour}$minute")).compareTo(
        int.parse("${b.hour}$minute2"),
      );
    });

    return reminderList;
  }

  update({required ReminderDB reminder}) async {
    await initDb();

    String query =
        "UPDATE $tableName SET $colTitle = ?, $colDes = ?, $colMinutes = ?, $colHours = ? WHERE $colId = ?";

    List args = [
      reminder.title,
      reminder.description,
      reminder.minute,
      reminder.hour,
      reminder.id,
    ];
    await db!.rawUpdate(query, args);
    fetchRecords();
  }

  delete({required int id}) async {
    await initDb();

    String query = "DELETE FROM $tableName WHERE $colId = $id";

    db!.rawDelete(query);

    fetchRecords();
  }
}
