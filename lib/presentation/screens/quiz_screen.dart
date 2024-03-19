import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/presentation/screens/main_menu_screen.dart';
import '../controllers/quiz_controller.dart';

class QuizPage extends StatelessWidget {
  final QuizController quizController = Get.put(QuizController());

  QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: GetBuilder<QuizController>(
        builder: (controller) {
          return controller.questions.isEmpty ? _buildLoading() : _buildBody();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody() {
    return GetBuilder<QuizController>(
      builder: (controller) {
        if (controller.quizEnded) {
          return _buildResultCard(controller);
        } else {
          return _buildQuiz(controller);
        }
      },
    );
  }

  Widget _buildQuiz(QuizController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
            'Question ${controller.currentQuestionIndex + 1} of ${controller.questions.length}'),
        const SizedBox(height: 20),
        Text('Time Remaining: ${controller.remainingTime} seconds'),
        const SizedBox(height: 20),
        Text('Score: ${controller.score}'),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          controller.questions[controller.currentQuestionIndex]
                                  .question ??
                              '',
                          style: const TextStyle(fontSize: 18),
                        ),
                        if (controller
                                    .questions[controller.currentQuestionIndex]
                                    .questionImageUrl !=
                                null &&
                            controller
                                    .questions[controller.currentQuestionIndex]
                                    .questionImageUrl !=
                                'null')
                          Image.network(
                            controller
                                .questions[controller.currentQuestionIndex]
                                .questionImageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        const SizedBox(height: 5),
                        _buildAnswerButtons(controller),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerButtons(QuizController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: controller.isAnswered
          ? _buildAnswerResult(controller)
          : _buildAnswerButtonsList(controller),
    );
  }

  List<Widget> _buildAnswerResult(QuizController controller) {
    return [
      if (controller.isTimeUp)
        const Text(
          'Time\'s up!',
          style: TextStyle(color: Colors.red),
        ),
      Text(
        controller.isCorrect ? 'Correct!' : 'Incorrect!',
        style:
            TextStyle(color: controller.isCorrect ? Colors.green : Colors.red),
      ),
      if (!controller.isCorrect)
        Text(
          'Correct answer: ${controller.questions[controller.currentQuestionIndex].correctAnswer}: ${controller.questions[controller.currentQuestionIndex].answers![controller.questions[controller.currentQuestionIndex].correctAnswer]} ',
          style: const TextStyle(color: Colors.green),
        ),
      const SizedBox(height: 20),
      FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Next question arriving in 2 seconds...',
                style: TextStyle(color: Colors.blue));
          } else {
            return const SizedBox(); // Hide the message after 2 seconds
          }
        },
      ),
    ];
  }

  List<Widget> _buildAnswerButtonsList(QuizController controller) {
    final answers = controller
        .questions[controller.currentQuestionIndex].answers!.entries
        .toList();
    return answers.map((entry) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => controller.selectAnswer(entry.key),
          child: Text(entry.value),
        ),
      );
    }).toList();
  }

  Widget _buildResultCard(QuizController controller) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(MainMenuScreen());
    });
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Quiz Result',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Total Score: ${controller.score}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                'Correct Answers: ${controller.correctAnswers}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              const Text(
                'Redirecting To Main Menu in 2 seconds...',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              // Add more details to the result card as needed
            ],
          ),
        ),
      ),
    );
  }
}
