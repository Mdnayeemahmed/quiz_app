import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/quiz_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';
import '../controllers/save_data_controller.dart';

class QuizController extends GetxController {
  List<QuizResponse> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int score = 0;
  bool isAnswered = false;
  bool isCorrect = false;
  bool isTimeUp = false;
  Timer? timer;
  bool quizEnded = false;
  bool getAllQuestionProgress = false;




  int totalQuizTime = 20;
  int remainingTime=20;

  @override
  void onInit() {
    super.onInit();
    resetQuiz();
    _getAllQuestion();
  }

  Future<void> _getAllQuestion() async {
    getAllQuestionProgress = true;
    update();
    try {
      final response = await NetworkCaller.getRequest(Urls.quiz);
      if (response.isSuccess) {
        final Map<String, dynamic> responseBody =
        response.responseBody as Map<String, dynamic>;
        final List<dynamic> questionsJson = responseBody['questions']
        as List<dynamic>; // Access 'questions' key
        questions = questionsJson.map((q) => QuizResponse.fromJson(q)).toList();
        update();
      } else {
        throw Exception('Failed to fetch questions');
      }
    } catch (e) {
      print('Error fetching questions: $e');
      // Handle error fetching questions
    }
  }

  void startTimer() {
    if (timer == null || !timer!.isActive) {
      const oneSecond = Duration(seconds: 1);
      timer = Timer.periodic(oneSecond, (timer) {
        if (remainingTime > 0) {
          remainingTime--;
          update();
        } else {
          timer.cancel();
          isTimeUp = true;
          moveNext();
          update();
        }
      });
    }
  }

  @override
  void onClose() {
    timer?.cancel(); // Cancel timer when widget is disposed
    super.onClose();
  }


  void selectAnswer(String selectedAnswer) {
    if (!isAnswered) {
      isAnswered = true;
      final correctAnswer = questions[currentQuestionIndex].correctAnswer;
      if (selectedAnswer == correctAnswer) {
        isCorrect = true;
        correctAnswers++;
        score += questions[currentQuestionIndex].score ?? 0;
      }
      timer?.cancel(); // Cancel the timer to store the remaining time
      update();
      Future.delayed(Duration(seconds: 2), () {
        moveNext();
      });
    }
  }

  void moveNext() async {
    if (isTimeUp) {
      await handleEndOfQuiz();
    } else if (currentQuestionIndex < questions.length - 1) {
      moveForwardToNextQuestion();
    } else {
      await handleEndOfQuiz();
    }
  }

  void moveForwardToNextQuestion() {
    currentQuestionIndex++;
    isAnswered = false;
    isCorrect = false;
    isTimeUp = false;
    if (remainingTime > 0) {
      startTimer();
    } else {
      moveNext();
    }
  }

  Future<void> handleEndOfQuiz() async {
    timer?.cancel();
    final previousScore = await SaveDataController.getUserScore();
    if (score > int.parse(previousScore ?? '0')) {
      final success = await SaveDataController.saveUserScore(score.toString());
      if (success) {
        print('User score saved successfully.');
      } else {
        print('Failed to save user score.');
      }
    } else {
      print('New score is not higher than the previous score.');
    }
    quizEnded = true;
    update();
  }


  void resetQuiz() {
    currentQuestionIndex = 0;
    correctAnswers = 0;
    score = 0;
    isAnswered = false;
    isCorrect = false;
    isTimeUp = false;
    remainingTime = totalQuizTime;
    quizEnded = false;
    questions.clear();
    _getAllQuestion();
    startTimer();
  }
}
