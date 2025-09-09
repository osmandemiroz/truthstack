# Truth Stack 🎴

A fun and engaging mobile game app built with Flutter that displays social questions for group activities. Perfect for parties, gatherings, or just hanging out with friends!

## Features ✨

- **Beautiful Card Stack Interface**: Swipeable cards with smooth animations following Apple's Human Interface Guidelines
- **40+ Social Questions**: Mix of fun, deep, and spicy questions to get conversations going
- **Three Categories**: 
  - 🎉 **Fun** - Light-hearted and entertaining questions
  - 💜 **Deep** - Thoughtful questions that spark meaningful conversations  
  - 🔥 **Spicy** - Bold questions that turn up the heat
- **Haptic Feedback**: Subtle vibrations enhance the user experience
- **Progress Tracking**: See how many questions you've gone through
- **Automatic Reshuffling**: Questions reshuffle when you reach the end

## Design Philosophy 🎨

The app follows Apple's Human Interface Guidelines with custom typography to deliver:
- **Elegant Typography**: Uses CinzelDecorative for titles, Raleway for body text, and TenorSans for labels
- Clean, minimal interface with focus on content
- Smooth, natural animations and transitions
- Beautiful gradients that change based on question category
- iOS-style interactions and feedback
- Dark theme for an elegant, modern appearance
- Custom font pairing for a unique, sophisticated look

## How to Run 🚀

1. **Prerequisites**:
   - Flutter SDK installed (3.0.0 or higher)
   - iOS Simulator or Android Emulator
   - Or a physical device for testing

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

   Or specify a device:
   ```bash
   flutter run -d iphone  # For iOS Simulator
   flutter run -d chrome  # For Web (preview)
   ```

## How to Play 🎮

1. Open the app on your phone
2. The top card shows a social question
3. Read the question out loud to your group
4. Everyone discusses or points to who fits the question best
5. Swipe the card away or tap it to reveal the next question
6. Use the undo button if you want to go back to a previous question

## Project Structure 📁

```
truthstack/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/
│   │   └── card_stack_screen.dart # Main game screen
│   ├── widgets/
│   │   └── question_card.dart    # Card widget with animations
│   ├── models/
│   │   └── question.dart         # Question data model
│   └── services/
│       └── question_service.dart # Question loading service
├── assets/
│   ├── questions/
│   │   └── questions.json        # All game questions
│   └── fonts/                    # SF Pro fonts (add if needed)
└── pubspec.yaml                   # Flutter dependencies
```

## Customization 🛠

### Adding More Questions
Edit `assets/questions/questions.json` to add your own questions. Each question needs:
- `id`: Unique identifier
- `text`: The question text
- `category`: Either "fun", "deep", or "spicy"

### Changing Colors
The gradient colors for each category can be modified in `lib/widgets/question_card.dart` in the `_getGradientColors()` method.

## Technologies Used 💻

- **Flutter**: Cross-platform mobile framework
- **flutter_card_swiper**: For swipeable card functionality
- **haptic_feedback**: For device vibration feedback
- **Cupertino widgets**: For iOS-style UI components

## Notes 📝

- The app uses custom fonts for an elegant, sophisticated look:
  - **CinzelDecorative**: For the main title and decorative elements
  - **Raleway**: For body text and questions (clean, readable)
  - **TenorSans**: For labels and small text (distinctive, modern)
- The app is optimized for portrait orientation
- Questions are randomized and tracked to avoid immediate repeats
- All fonts are included in the `assets/fonts/` directory

Enjoy the game! 🎉
