import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truthstack/screens/card_stack_screen.dart';

/// Main entry point for the Truth Stack app
/// A fun social questions card game following Apple's Human Interface Guidelines
void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for better card experience)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TruthStackApp());
}

/// Root widget of the Truth Stack application
/// Implements a modern, minimal design with smooth animations
class TruthStackApp extends StatelessWidget {
  const TruthStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth Stack',
      debugShowCheckedModeBanner: false,

      // Theme configuration following Apple HIG
      theme: ThemeData(
        // Use Material 3 (Material You) for modern design
        useMaterial3: true,

        // Color scheme with dark theme for elegant appearance
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF06FFA5),
          secondary: Color(0xFF667EEA),
          surface: Color(0xFF1a1a2e),
        ),

        // Typography using custom fonts for elegant design
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'CinzelDecorative',
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
          displayMedium: TextStyle(
            fontFamily: 'CinzelDecorative',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
          labelLarge: TextStyle(
            fontFamily: 'TenorSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),

        // Platform-specific adaptations
        platform: TargetPlatform.iOS,

        // Page transitions with iOS-style animations
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),

      // Start with the card stack screen
      home: const CardStackScreen(),

      // Custom scroll behavior for iOS-like bouncing
      scrollBehavior: const _IOSScrollBehavior(),
    );
  }
}

/// Custom scroll behavior for iOS-like bouncing effect
/// Provides a more native feel on all platforms
class _IOSScrollBehavior extends ScrollBehavior {
  const _IOSScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Use Cupertino scrollbar for iOS appearance
    return CupertinoScrollbar(
      controller: details.controller,
      child: child,
    );
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Use bouncing scroll physics like iOS
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Remove the Android overscroll glow
    return child;
  }
}
