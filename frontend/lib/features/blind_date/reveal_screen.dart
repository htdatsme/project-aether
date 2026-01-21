import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/widgets/generative_scaffold.dart';
import '../vibe_engine/vibe_controller.dart';

class RevealScreen extends ConsumerStatefulWidget {
  const RevealScreen({super.key});

  @override
  ConsumerState<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends ConsumerState<RevealScreen> {
  bool _isRevealed = false;
  bool _isFlashing = false;

  void _handleReveal() async {
    // 1. Haptic
    HapticFeedback.heavyImpact();

    // 2. Flash
    setState(() {
      _isFlashing = true;
    });
    
    // 3. Log Data (The Moat)
    ref.read(vibeProvider.notifier).logGroundTruth();
    // CRITICAL: Proof of Data Moat
    debugPrint("DATA MOAT: Ground Truth Logged for Vibe Session.");

    // Wait for flash peak
    await Future.delayed(const Duration(milliseconds: 100));

    // 4. Reveal & Remove Flash
    setState(() {
      _isRevealed = true;
      _isFlashing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GenerativeScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. The Hidden Object (Bottle)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_drink_rounded, // Bottle Icon
                  size: 200,
                  color: Colors.black.withOpacity(0.8),
                ).animate(target: _isRevealed ? 1 : 0).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 800.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 20),
                if (_isRevealed)
                  Text(
                    "VERIFIED MATCH",
                    style: Theme.of(context).textTheme.labelLarge,
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5, end: 0)
              ],
            ),
          ),

          // 2. The Frosted Glass Layer (Obscures the object)
          IgnorePointer(
            ignoring: true, // Allow touches to pass through if needed, but we have a button on top
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _isRevealed ? 0 : 20.0,
                  sigmaY: _isRevealed ? 0 : 20.0,
                ),
                child: Container(
                  color: Colors.white.withOpacity(_isRevealed ? 0.0 : 0.2),
                ),
              ),
            ),
          ),

          // 3. Interaction Layer (Button)
          if (!_isRevealed)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTapDown: (_) => HapticFeedback.mediumImpact(),
                  onTapUp: (_) => _handleReveal(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(0.05),
                    ),
                    child: Text(
                      "PRESS AND HOLD TO REVEAL",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),

          // 4. White Flash Overlay
          IgnoredPointer(
            child: AnimatedOpacity(
              opacity: _isFlashing ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200), // Quick flash
              child: Container(color: Colors.white),
            ),
          ),
          
          // Back button for testing
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
// Helper wrapper to avoid pointer events blocking
class IgnoredPointer extends StatelessWidget {
  final Widget child;
  const IgnoredPointer({super.key, required this.child});
  @override
  Widget build(BuildContext context) => IgnorePointer(child: child);
}
