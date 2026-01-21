import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/generative_theme.dart';

class GenerativeScaffold extends StatelessWidget {
  final Widget child;
  final Widget? drawer;

  const GenerativeScaffold({Key? key, required this.child, this.drawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GenerativeTheme>();
    // Fallback if theme is missing (though it shouldn't be)
    final safeTheme = theme ?? GenerativeTheme.champagne();

    return Scaffold(
      drawer: drawer,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      drawerScrimColor: Colors.black.withOpacity(0.2),
      backgroundColor: const Color(0xFFFAF9F6), // Match Layer 1
      body: Stack(
        children: [
          // Layer 2 (The Fluid)
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  safeTheme.vibeStartColor.withOpacity(0.3),
                  safeTheme.vibeEndColor.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Layer 4 (The Glass)
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: safeTheme.blurSigma,
              sigmaY: safeTheme.blurSigma,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),

          // Body
          SafeArea(child: child),
        ],
      ),
    );
  }
}
