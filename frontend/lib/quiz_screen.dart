import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';

class QuizStep extends Notifier<int> {
  @override
  int build() => 0;
  void next() => state++;
}

final quizStepProvider = NotifierProvider<QuizStep, int>(QuizStep.new);

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(quizStepProvider);
    
    final questions = [
      {
        'question': 'Which atmosphere resonates with you?',
        'options': ['Rain-soaked cobblestones', 'Sun-drenched Mediterranean citrus', 'A smoke-filled jazz club'],
      },
      {
        'question': 'Select a desired texture...',
        'options': ['Silk and velvet', 'Crisp linen', 'Raw leather'],
      },
      {
        'question': 'What is your preferred time of day?',
        'options': ['First light', 'Golden hour', 'Midnight'],
      }
    ];

    if (step >= questions.length) {
      return const GeneratingResultsScreen();
    }

    final currentQuestion = questions[step];

    return Scaffold(
      backgroundColor: AetherTheme.obsidian,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (step + 1) / questions.length,
                backgroundColor: AetherTheme.glass,
                color: AetherTheme.champagne,
              ).animate().fadeIn(),
              
              const SizedBox(height: 60),
              
              Text(
                'QUESTION ${step + 1}',
                style: const TextStyle(color: AetherTheme.champagne, letterSpacing: 2),
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 12),
              
              Text(
                currentQuestion['question'] as String,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 48),
              
              ...(currentQuestion['options'] as List<String>).map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () => ref.read(quizStepProvider.notifier).next(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AetherTheme.glass,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneratingResultsScreen extends StatefulWidget {
  const GeneratingResultsScreen({super.key});

  @override
  State<GeneratingResultsScreen> createState() => _GeneratingResultsScreenState();
}

class _GeneratingResultsScreenState extends State<GeneratingResultsScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate API call
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
         // Would navigate to results
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AetherTheme.obsidian,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, color: AetherTheme.champagne, size: 64)
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 1500.ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
            const SizedBox(height: 24),
            Text(
              'CURATING YOUR OLFACTORY PROFILE',
              style: TextStyle(color: AetherTheme.champagne.withOpacity(0.8), letterSpacing: 4),
            ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }
}
