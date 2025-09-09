import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:haptic_feedback/haptic_feedback.dart' as haptics;
import 'package:truthstack/models/question.dart';
import 'package:truthstack/services/question_service.dart';
import 'package:truthstack/widgets/question_card.dart';

/// Main screen displaying the swipeable card stack
/// Implements Apple's Human Interface Guidelines with smooth animations,
/// haptic feedback, and a minimal, elegant design
class CardStackScreen extends StatefulWidget {
  const CardStackScreen({super.key});

  @override
  State<CardStackScreen> createState() => _CardStackScreenState();
}

class _CardStackScreenState extends State<CardStackScreen>
    with TickerProviderStateMixin {
  final CardSwiperController _cardController = CardSwiperController();
  List<Question> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  /// Animation controllers for UI elements
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  /// Track swipe direction for visual feedback - reserved for future use
  // double _swipeProgress = 0.0;
  // bool _isSwipingRight = false;

  @override
  void initState() {
    super.initState();

    // Initialize background animation
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    _loadQuestions();
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  /// Load questions from the service
  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    await QuestionService.loadQuestions();

    // Get all questions and shuffle them
    final allQuestions = QuestionService.getAllQuestions();

    setState(() {
      _questions = allQuestions;
      _isLoading = false;
    });
  }

  /// Handle card swipe completion
  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    // Provide haptic feedback for better user experience
    await haptics.Haptics.vibrate(haptics.HapticsType.light);

    setState(() {
      _currentIndex = currentIndex ?? 0;
      // _swipeProgress = 0.0;  // Reserved for future swipe progress tracking
    });

    // Check if we need to loop back to the beginning
    if (currentIndex == null || currentIndex >= _questions.length - 1) {
      _reshuffleQuestions();
    }

    return true;
  }

  /// Reshuffle questions when reaching the end
  void _reshuffleQuestions() {
    QuestionService.shuffleQuestions();
    setState(() {
      _questions = QuestionService.getAllQuestions();
    });

    // Show a subtle notification
    _showNotification('Deck reshuffled! 🎲');
  }

  /// Show a subtle notification using iOS-style presentation
  void _showNotification(String message) {
    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Handle undo action
  Future<void> _handleUndo() async {
    // Provide haptic feedback
    await haptics.Haptics.vibrate(haptics.HapticsType.medium);

    _cardController.undo();

    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  /// Build the gradient background with animation
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                  _backgroundAnimation.value,
                )!,
                Color.lerp(
                  const Color(0xFF0f0e1a),
                  const Color(0xFF1e1e2e),
                  _backgroundAnimation.value,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Truth Stack',
          style: TextStyle(
            fontFamily: 'CinzelDecorative',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          // Undo button with animation
          IconButton(
            onPressed: _currentIndex > 0 ? _handleUndo : null,
            icon: Icon(
              CupertinoIcons.arrow_uturn_left_circle_fill,
              color: _currentIndex > 0
                  ? Colors.white.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.3),
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Animated gradient background
          _buildAnimatedBackground(),

          // Decorative elements for depth
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: _isLoading ? _buildLoadingState() : _buildCardStack(),
          ),

          // Bottom indicator showing progress
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildProgressIndicator(),
          ),
        ],
      ),
    );
  }

  /// Build loading state with animation
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom loading animation
          const CupertinoActivityIndicator(
            radius: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            'Preparing your questions...',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the main card stack
  Widget _buildCardStack() {
    if (_questions.isEmpty) {
      return Center(
        child: Text(
          'No questions available',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.6),
            letterSpacing: 0.3,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Instructions text with fade animation
        AnimatedOpacity(
          opacity: _currentIndex == 0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Text(
              'Swipe or tap cards to reveal questions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.6),
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),

        // Card stack
        Expanded(
          child: CardSwiper(
            controller: _cardController,
            cardsCount: _questions.length,
            numberOfCardsDisplayed: 3,
            backCardOffset: const Offset(0, -40),
            padding: const EdgeInsets.all(20),
            onSwipe: _onSwipe,
            onUndo: (previousIndex, currentIndex, direction) {
              setState(() {
                _currentIndex = currentIndex;
              });
              return true;
            },
            cardBuilder: (
              context,
              index,
              horizontalThresholdPercentage,
              verticalThresholdPercentage,
            ) {
              // Ensure index is within bounds
              if (index >= _questions.length) {
                return const SizedBox.shrink();
              }

              return QuestionCard(
                question: _questions[index],
                isTopCard: index == _currentIndex,
                onTap: () async {
                  // Provide haptic feedback
                  await haptics.Haptics.vibrate(haptics.HapticsType.selection);
                  // Swipe right on tap
                  _cardController.swipe(CardSwiperDirection.right);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build progress indicator at the bottom
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Progress text
          Text(
            '${_currentIndex + 1} / ${_questions.length}',
            style: TextStyle(
              fontFamily: 'TenorSans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),

          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: _questions.isEmpty
                    ? 0
                    : (_currentIndex + 1) / _questions.length,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
