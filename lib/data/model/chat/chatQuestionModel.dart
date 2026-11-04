class ChatQuestionModel {
  final int id;
  final String question;

  ChatQuestionModel({required this.id, required this.question});

  factory ChatQuestionModel.fromJson(Map<String, dynamic> json) {
    return ChatQuestionModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      question: json['question']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'question': question};
  }
}
