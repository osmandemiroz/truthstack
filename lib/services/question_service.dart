import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:truthstack/models/question.dart';

/// Supported languages for questions
enum QuestionLanguage { english, turkish }

/// Service class responsible for loading and managing questions
/// Handles JSON parsing and provides randomized question access
class QuestionService {
  static List<Question> _questions = [];
  static final Random _random = Random();

  /// Current language for questions
  static QuestionLanguage _currentLanguage = QuestionLanguage.english;

  /// Tracks which questions have been shown to avoid immediate repeats
  static final Set<int> _shownQuestionIds = {};

  /// Load questions from the JSON file in assets based on current language
  /// This should be called when the app starts or when language changes
  static Future<void> loadQuestions() async {
    try {
      // Determine which questions file to load based on current language
      final questionsFile = _currentLanguage == QuestionLanguage.turkish
          ? 'assets/questions/questions_tr.json'
          : 'assets/questions/questions.json';

      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString(questionsFile);

      // Parse the JSON data
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final questionList = jsonData['questions'] as List<dynamic>;

      // Convert JSON array to List<Question>
      _questions = questionList
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();

      // Shuffle the questions for randomness
      _questions.shuffle(_random);

      // Clear shown questions when loading new language
      _shownQuestionIds.clear();
    } on Exception catch (e, s) {
      // Fallback questions in case JSON loading fails
      _questions = _getFallbackQuestions();
      if (kDebugMode) {
        print('[QuestionService.loadQuestions] Error loading questions: $e');
        print('Stack trace: $s');
      }
    }
  }

  /// Set the language for questions and reload them
  static Future<void> setLanguage(QuestionLanguage language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      await loadQuestions();
    }
  }

  /// Get current language
  static QuestionLanguage getCurrentLanguage() => _currentLanguage;

  /// Get all loaded questions
  static List<Question> getAllQuestions() {
    return List.unmodifiable(_questions);
  }

  /// Get a random question that hasn't been shown recently
  /// Resets the shown questions when all have been displayed
  static Question getRandomQuestion() {
    if (_questions.isEmpty) {
      return const Question(
        id: 0,
        text: 'Who would survive longest on a deserted island?',
        category: 'fun',
      );
    }

    // Reset shown questions if we've shown them all
    if (_shownQuestionIds.length >= _questions.length) {
      _shownQuestionIds.clear();
    }

    // Find questions that haven't been shown yet
    final unshownQuestions =
        _questions.where((q) => !_shownQuestionIds.contains(q.id)).toList();

    // Pick a random unshown question
    final selectedQuestion = unshownQuestions.isNotEmpty
        ? unshownQuestions[_random.nextInt(unshownQuestions.length)]
        : _questions[_random.nextInt(_questions.length)];

    // Mark this question as shown
    _shownQuestionIds.add(selectedQuestion.id);

    return selectedQuestion;
  }

  /// Get questions by category
  /// Useful for future filtering features
  static List<Question> getQuestionsByCategory(String category) {
    return _questions
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Shuffle all questions
  /// Can be called to re-randomize the order
  static void shuffleQuestions() {
    _questions.shuffle(_random);
    _shownQuestionIds.clear(); // Reset tracking when shuffling
  }

  /// Fallback questions in case JSON loading fails
  /// Ensures the app can still function without the JSON file
  static List<Question> _getFallbackQuestions() {
    return [
      const Question(
          id: 1,
          text: 'Who would survive longest in a zombie apocalypse?',
          category: 'fun'),
      const Question(
          id: 2, text: 'Who gives the best advice?', category: 'deep'),
      const Question(
          id: 3, text: 'Who is most likely to become famous?', category: 'fun'),
      const Question(
          id: 4,
          text: 'Who would you trust with your biggest secret?',
          category: 'deep'),
      const Question(id: 5, text: 'Who has the best laugh?', category: 'fun'),
    ];
  }
}
