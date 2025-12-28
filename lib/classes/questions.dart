class Question {
  final String questionText;
  final bool answerVal;
  Question(this.questionText, this.answerVal);

// factory constructor to create a Question object from JSON. This constructor takes a Map<String, dynamic> as input and returns a Question object
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      json['question'],
      json['answer'] == 1,
    );
  }
}
