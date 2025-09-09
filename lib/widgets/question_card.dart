import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truthstack/models/question.dart';

/// A beautiful card widget that displays a question
/// Follows Apple's Human Interface Guidelines with smooth animations
/// and a modern, minimal design aesthetic
class QuestionCard extends StatefulWidget {
  const QuestionCard({
    required this.question,
    super.key,
    this.isTopCard = false,
    this.onTap,
  });
  final Question question;
  final bool isTopCard; // Whether this is the top card in the stack
  final VoidCallback? onTap;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  /// Track if the card is being pressed for visual feedback
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for smooth transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale animation for entrance effect
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Subtle rotation animation for depth
    _rotationAnimation = Tween<double>(
      begin: 0.02,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start the entrance animation
    if (widget.isTopCard) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get gradient colors based on question category
  /// Each category has its own beautiful gradient scheme
  List<Color> _getGradientColors() {
    switch (widget.question.category.toLowerCase()) {
      case 'spicy':
        // Warm, intense gradient for spicy questions
        return [
          const Color(0xFFFF6B6B),
          const Color(0xFFFF8E53),
        ];
      case 'deep':
        // Cool, thoughtful gradient for deep questions
        return [
          const Color(0xFF667EEA),
          const Color(0xFF764BA2),
        ];
      case 'fun':
      default:
        // Playful, energetic gradient for fun questions
        return [
          const Color(0xFF06FFA5),
          const Color(0xFF00C9FF),
        ];
    }
  }

  /// Get category icon based on question type
  IconData _getCategoryIcon() {
    switch (widget.question.category.toLowerCase()) {
      case 'spicy':
        return CupertinoIcons.flame_fill;
      case 'deep':
        return CupertinoIcons.heart_fill;
      case 'fun':
      default:
        return CupertinoIcons.sparkles;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? 0.95 : _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    // Main card container with gradient
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors,
                        ),
                        boxShadow: [
                          // Soft shadow for depth - following Apple's subtle shadow approach
                          BoxShadow(
                            color: gradientColors[0].withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          // Additional shadow for more depth
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          children: [
                            // Subtle pattern overlay for texture
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _PatternPainter(),
                              ),
                            ),

                            // Content container
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Category icon with animation
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    transform: Matrix4.identity()
                                      ..scaleByDouble(
                                          _isPressed ? 0.8 : 1.0,
                                          _isPressed ? 0.8 : 1.0,
                                          _isPressed ? 0.8 : 1.0,
                                          1),
                                    child: Icon(
                                      _getCategoryIcon(),
                                      size: 50,
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Question text with beautiful typography
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: _isPressed ? 24 : 26,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.4,
                                      letterSpacing: 0.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    child: Text(
                                      widget.question.text,
                                    ),
                                  ),

                                  const SizedBox(height: 40),

                                  // Category label
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      widget.question.category.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'TenorSans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Shine effect overlay for premium feel
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.2),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                                    stops: const [0.0, 0.3, 0.7, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for subtle pattern overlay
/// Adds visual texture to the cards
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Create a subtle dot pattern
    const double spacing = 30;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Add some randomness to the pattern
        if ((x + y) % (spacing * 2) == 0) {
          canvas.drawCircle(Offset(x, y), 2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
