import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:quiz_app/presentation/screens/main_menu_screen.dart';

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,


        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white



        ),
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/logo.png'), // Replace with your splash image
        splashIconSize: double.infinity,
        nextScreen: MainMenuScreen(),
        splashTransition: SplashTransition.sizeTransition,

        duration: 500, // Adjust the duration as needed (milliseconds)
      ),
    );
  }
}