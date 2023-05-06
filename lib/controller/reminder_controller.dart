import 'package:get/get.dart';
import 'package:reminder_app/modals/reminder.dart';

class ReminderController extends GetxController{
  RxInt year = 0.obs;
  RxInt month = 0.obs;
  RxInt day = 0.obs;
  RxInt hour = 0.obs;
  RxInt minute= 0.obs;

  RxList<ReminderDB> reminders =<ReminderDB>[].obs;

  setTime({required int hourV, required int minuteV}){
    hour.value = hourV;
    minute.value = minuteV;
  }
  clearTime(){
  hour.value=0;
  minute.value=0;
  }
}