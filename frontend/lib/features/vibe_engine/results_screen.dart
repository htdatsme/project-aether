import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/generative_scaffold.dart';
import 'vibe_controller.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  // 🛠️ UPGRADED LOGIC: Checks both Name and Description for keywords
  String _getImageForScent(String name, String description) {
    final text = "$name $description".toLowerCase();

    // 1. The Fresh / Water Family -> 'fresh_bottle.png'
    if (text.contains('water') || text.contains('aqua') || text.contains('sea') || 
        text.contains('fresh') || text.contains('ocean') || text.contains('citrus') ||
        text.contains('blue') || text.contains('summer')) {
      return 'assets/images/fresh_bottle.png';  // <--- CORRECTED NAME
    }
    
    // 2. The Dark / Woody Family -> 'dark_bottle.png'
    if (text.contains('dark') || text.contains('night') || text.contains('wood') || 
        text.contains('oud') || text.contains('intense') || text.contains('smoke') ||
        text.contains('leather') || text.contains('tobacco') || text.contains('black')) {
      return 'assets/images/dark_bottle.png';   // <--- CORRECTED NAME
    }
    
    // 3. Fallback for others (Floral/Earth) -> 'generic_bottle.png'
    // (Unless you actually have floral_bottle.png, we should fallback to generic)
    return 'assets/images/generic_bottle.png';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibeState = ref.watch(vibeProvider);
    final theme = Theme.of(context);
    
    // Watch state
    final isLoading = vibeState.isLoading;
    final matchData = vibeState.analysisResult;
    
    // Extract data or use safely (if loading, emptiness is fine as we hide it)
    final scentName = matchData?['scent_name'] ?? 'Unknown Scent';
    final matchReason = matchData?['match_reason'] ?? 'Divining your essence...';
    final aiReasoning = matchData?['ai_reasoning'] ?? '';
    
    // 🛠️ CHANGED: Pass both name and description to the smart switch
    final imagePath = _getImageForScent(scentName, matchReason);

    return GenerativeScaffold(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 20),
                child: Text(
                  "The Oracle Speaks",
                  style: theme.textTheme.displayMedium,
                ).animate().fadeIn(duration: 800.ms).moveY(begin: 20, end: 0),
              ),
              
              SizedBox(
                height: MediaQuery.of(context).size.height - 140,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CoalescingBottle(
                        scentName: scentName,
                        description: matchReason,
                        imagePath: imagePath,
                        isLoading: isLoading,
                      ),
                    ),
                    if (!isLoading && aiReasoning.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: vibeState.theme.goldAccent.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI REASONING",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: vibeState.theme.goldAccent,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                aiReasoning,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 1000.ms, delay: 1500.ms),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoalescingBottle extends ConsumerWidget {
  final String scentName;
  final String description;
  final String imagePath;
  final bool isLoading;

  const CoalescingBottle({
    super.key,
    required this.scentName,
    required this.description,
    required this.imagePath,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibeState = ref.watch(vibeProvider);
    final theme = vibeState.theme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 400,
            width: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Molecular "Gas" Layer
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.goldAccent.withOpacity(0.4),
                        theme.vibeEndColor.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 3000.ms, curve: Curves.easeInOutSine)
                .blur(begin: const Offset(20, 20), end: const Offset(40, 40)),

                // 2. The Coalescing Core
                AnimatedContainer(
                  duration: 2000.ms,
                  curve: Curves.easeInOutExpo,
                  width: isLoading ? 150 : 200,
                  height: isLoading ? 150 : 320,
                  decoration: BoxDecoration(
                    color: theme.vibeEndColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isLoading ? 100 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.goldAccent.withOpacity(isLoading ? 0.3 : 0.1),
                        blurRadius: isLoading ? 50 : 20,
                        spreadRadius: isLoading ? 10 : 0,
                      )
                    ],
                  ),
                ),

                // 3. The Solid Image (The Reveal)
                if (!isLoading)
                  Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: 180,
                    errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.auto_awesome, color: theme.goldAccent, size: 80),
                  )
                  .animate()
                  .fadeIn(duration: 1200.ms, curve: Curves.easeInCirc)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 1200.ms)
                  .shimmer(duration: 3000.ms, color: Colors.white.withOpacity(0.3)),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        if (!isLoading) ...[
          Text(
            scentName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms, delay: 800.ms).moveY(begin: 10, end: 0),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 800.ms, delay: 1000.ms),
          ),
        ] else ...[
          Text(
            "Consulting the Ether...",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: theme.goldAccent.withOpacity(0.8),
              letterSpacing: 4.0,
            ),
          ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 1000.ms).then().fadeOut(duration: 1000.ms),
        ]
      ],
    );
  }
}