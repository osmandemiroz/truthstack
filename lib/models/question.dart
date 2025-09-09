/// Model class representing a social question in the game
/// Each question has an ID, text content, and a category for filtering
class Question {
  const Question({
    required this.id,
    required this.text,
    required this.category,
  });

  /// Factory constructor to create a Question from JSON data
  /// Used when parsing the questions.json file
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      category: json['category'] as String,
    );
  }
  final int id;
  final String text;
  final String category;

  /// Convert the Question instance to a Map
  /// Useful for serialization if needed in the future
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Question(id: $id, category: $category, text: $text)';
  }
}
