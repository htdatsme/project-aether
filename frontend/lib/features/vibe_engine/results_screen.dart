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
                // We pass the controller state down
                child: CoalescingBottle(
                  scentName: scentName,
                  description: matchReason,
                  imagePath: imagePath,
                  isLoading: isLoading,
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

    // Logic:
    // 1. If isLoading = true, we run the "Gas/Pulse" animation loop.
    // 2. We use target: isLoading ? 0 : 1 to drive the Coalescence progress.
    // 3. The Solid Bottle only fades in when isLoading becomes false.

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The Coalescing Object
        Center(
          child: SizedBox(
            height: 400,
            width: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
              // 1. The "Gas" Layer (The Orb -> Transform to Bottle)
              Container(
                width: 200,
                height: 350,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      theme.goldAccent.withOpacity(0.8),
                      theme.vibeEndColor.withOpacity(0.4),
                      Colors.transparent,
                    ],
                    stops: const [0.2, 0.6, 1.0],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                ),
              )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              // This Loop runs regardless, keeping the gas alive
              .scaleXY(begin: 1.0, end: 1.05, duration: 2000.ms, curve: Curves.easeInOut)

              // The Coalescence Transition (triggered when not loading)
              .animate(
                target: isLoading ? 0 : 1, 
              )
              .custom(
                duration: 2000.ms,
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  // value 0 -> 1 (Coalescing)
                  // value 0: Gas State (Circle, Large, Blurred)
                  // value 1: Bottle State (Rect, Small, Sharp)
                  
                  final radius = lerpDouble(1000, 20, value)!;
                  final scale = lerpDouble(1.5, 1.0, value)!;
                  final blur = lerpDouble(30, 0, value)!;

                  return Transform.scale(
                    scale: scale,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.vibeEndColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(radius),
                          boxShadow: [
                             BoxShadow(
                                color: theme.goldAccent.withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: -10,
                             )
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: child, // The gradient gradient is the child here
                      ),
                    ),
                  );
                },
              ),

              // 2. The "Solid" Layer (The Bottle Image)
              // Only reveal when data is ready (isLoading = false)
              if (!isLoading)
                Container(
                  width: 200,
                  height: 350,
                  decoration: BoxDecoration(
                    // Glassy look
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.goldAccent.withOpacity(0.5), width: 1),
                  ),
                  child: Center(
                    // DYNAMIC IMAGE: Use the mapped asset
                    // Note: If asset is missing, this will throw.
                    // Ideally we'd wrap in error builder, but user asked for specific paths.
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      width: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, color: theme.goldAccent, size: 50);
                      },
                    )
                    .animate()
                    .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.2)),
                  ),
                )
                .animate()
                .fadeIn(duration: 1000.ms, delay: 500.ms, curve: Curves.easeIn),
            ],
          ),
        ),
      ),
        
        const SizedBox(height: 40),
        
        // Text Info (The Reveal)
        // Only show when loaded
        if (!isLoading) ...[
          Text(
            scentName,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms, delay: 1000.ms),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 800.ms, delay: 1200.ms),
          ),
        ] else ...[
             Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Consulting the Ether...",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: theme.goldAccent.withOpacity(0.7)
              ),
            ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 1000.ms).then().fadeOut(duration: 1000.ms),
          ),
        ]
      ],
    );
  }
}