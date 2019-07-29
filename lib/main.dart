import 'package:erply_app_assignment/screens/confirm_login_page.dart';
import 'package:erply_app_assignment/screens/home_page.dart';
import 'package:erply_app_assignment/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/routes_constants.dart';
import 'constants/theme.dart';
import 'screens/login_page.dart';

Future<void> main() async {
  AuthService authService = AuthService();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  var currentUser = await authService.isUserSessionActive();
  runApp(MyApp(currentUser: currentUser));
}

class MyApp extends StatelessWidget {
  final dynamic currentUser;
  MyApp({this.currentUser});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      color: APPLY_GRAY,
      theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme.of(context).copyWith(
            color: APPLY_YELLOW,
            iconTheme: IconThemeData(color: Colors.black),
            brightness: Brightness.dark,
            textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold),
            ),
            actionsIconTheme: IconThemeData(color: Colors.black),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: APPLY_GRAY,
            foregroundColor: Colors.black,
            elevation: 0.0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.none,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          primaryColor: APPLY_BLUE),
      initialRoute: currentUser ? KConfirmScreen : KDefaultScreen,
      routes: {
        KDefaultScreen: (context) => LoginPage(),
        KHomeScreen: (context) => HomePage(),
        KConfirmScreen: (context) => ConfirmLoginPage(),
      },
    );
  }
}
