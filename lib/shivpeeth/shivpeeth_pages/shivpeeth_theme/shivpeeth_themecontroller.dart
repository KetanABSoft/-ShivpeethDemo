import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:messeges_with_firebase/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_theme.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constant/conurl.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_color.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_icons.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_prefsname.dart';
import '../shivpeeth_Authentication/shivpeeth_login.dart';
import '../shivpeeth_adapter/notice_adapter.dart';
import '../shivpeeth_theme/shivpeeth_themecontroller.dart';



class WireframeThemecontroler extends GetxController{
  @override
  void onInit()
  {
    // SharedPreferences.getInstance().then((value) {
    //   isdark = value.getBool(wireframeDarkMode)!;
    // });

    try {
  SharedPreferences.getInstance().then((value) {
    if (value != Null) {
      isdark = value.getBool(wireframeDarkMode) ?? false;
    } else {
      // Handle the case where SharedPreferences instance is null.
      // You might want to set a default value for isdark or handle it differently.
    }
  });
} catch (e) {
  // Handle exceptions here.
  print("Error fetching SharedPreferences: $e");
}

    update();
    super.onInit();
  }

  var isdark = false;
  Future<void> changeTheme (state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isdark = prefs.getBool(wireframeDarkMode) ?? true;
    isdark = !isdark;

    if (state == true) {
      Get.changeTheme(WireframeMythemes.darkTheme);
      isdark = true;
    }
    else {
      Get.changeTheme(WireframeMythemes.lightTheme);
      isdark = false;
    }
    update();
  }

}