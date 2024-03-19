class QuizResponse {
  String? question;
  Map<String, String>? answers;
  String? questionImageUrl;
  String? correctAnswer;
  int? score;

  QuizResponse({
    this.question,
    this.answers,
    this.correctAnswer,
    this.score,
    this.questionImageUrl,
  });

  QuizResponse.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = Map<String, String>.from(json['answers']);
    questionImageUrl = json['questionImageUrl'];
    correctAnswer = json['correctAnswer'];
    score = json['score'];
  }
}
