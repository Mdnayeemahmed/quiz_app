import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/presentation/screens/quiz_screen.dart';

import '../controllers/quiz_controller.dart';
import '../controllers/save_data_controller.dart';

class MainMenuScreen extends StatefulWidget {
  MainMenuScreen({Key? key}) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String? highestScore;
  final QuizController quizController = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
    getUserScore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.isCurrent) {
      getUserScore();
    }
  }

  void getUserScore() async {
    highestScore = await SaveDataController.getUserScore();
    setState(() {
      print(highestScore);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz App',
          style: TextStyle(fontFamily: 'Pacifico', fontSize: 24.0),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                quizController.resetQuiz();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text(
                'Start New Game',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Highest Score: ${highestScore ?? 0}',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
