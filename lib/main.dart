import 'package:data_users/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

 bool? logged ;
 int? balance ;
Future isLogged() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  logged=prefs.getBool('logged');
    balance=prefs.getInt('balance');

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await isLogged();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(logged);
    print(balance);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: logged != true ? LoginScreen() : Home(balance: balance??0),
    );
  }
}
