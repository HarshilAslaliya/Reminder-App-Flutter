import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderThemeController extends GetxController{
  RxBool darkTheme = false.obs;

  changeTheme(){
    darkTheme.value=!darkTheme.value;
    Get.changeTheme(Get.isDarkMode?ThemeData.light(useMaterial3: true):ThemeData.dark(useMaterial3: true));
  }
}