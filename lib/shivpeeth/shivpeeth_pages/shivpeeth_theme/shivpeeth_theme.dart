import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constant/conurl.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_color.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';
import '../../shivpeeth_gloabelclass/shivpeeth_icons.dart';
import '../shivpeeth_Authentication/shivpeeth_login.dart';
import '../shivpeeth_adapter/notice_adapter.dart';
import '../shivpeeth_theme/shivpeeth_themecontroller.dart';



class WireframeMythemes {
  static final lightTheme = ThemeData(

    primaryColor: WireframeColor.appcolor,
    primarySwatch: Colors.grey,
    textTheme: const TextTheme(),
    fontFamily: 'SourceSansProRegular',
    scaffoldBackgroundColor: WireframeColor.white,
    appBarTheme: AppBarTheme(
      iconTheme:  const IconThemeData(color: WireframeColor.black),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: sansproRegular.copyWith(
        color: WireframeColor.black,
        fontSize: 16,
      ),
      color: WireframeColor.transparent,
    ),
  );

  static final darkTheme = ThemeData(

    fontFamily: 'SourceSansProRegular',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: WireframeColor.white),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: sansproRegular.copyWith(
        color: WireframeColor.white,
        fontSize: 15,
      ),
      color: WireframeColor.transparent,
    ),
  );
}