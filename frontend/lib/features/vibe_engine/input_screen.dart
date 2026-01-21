import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/generative_scaffold.dart';
import 'vibe_controller.dart';
import 'results_screen.dart';
import '../blind_date/reveal_screen.dart';

class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_controller.text.isEmpty) return;
    
    // Call the Vibe Engine
    ref.read(vibeProvider.notifier).analyzeVibe(_controller.text);

    // Navigate to Results immediately so it can show loading state
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ResultsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch state to show loading if needed, though instructions said use fade/breathing animation
    // which implies we might show loading ON the result screen or here.
    // "On submit, call vibeController.analyzeVibe()". then "Create ResultsScreen...".
    // I'll navigate immediately or await. 
    // The prompt says "Loading State: Use a subtle fade/breathing animation".
    // I'll assume we stay here or go to a loading view.
    // For simplicity, I'll await then push, but maybe show a loading indicator here?
    // Or maybe the Results Screen handles the loading state.
    // I'll stick to: Await -> Push. If it takes time, the user sees nothing??
    // Let's add a small indicator on the button or screen.
    final vibeState = ref.watch(vibeProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: GenerativeScaffold(
        // Side Menu as requested for testing
        drawer: Drawer(
          backgroundColor: theme.scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1)),
                child: Center(
                  child: Text('Debug Menu', style: theme.textTheme.headlineSmall),
                ),
              ),
              ListTile(
                title: Text('Test: Blind Date Reveal', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RevealScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The Question
                    Text(
                      'Describe your Essence',
                      style: theme.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 60),

                    // The Input Field
                    Material(
                      color: Colors.transparent,
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: theme.textTheme.headlineSmall,
                        cursorColor: const Color(0xFFD4AF37), // Gold cursor
                        decoration: InputDecoration.collapsed(
                          hintText: 'e.g., A rainy afternoon in London...',
                          hintStyle: theme.textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF1A1A1A).withOpacity(0.4),
                          ),
                        ),
                        // GenUI Logic: Shift gradient as user types
                        onChanged: (text) {
                          ref.read(vibeProvider.notifier).updateVibeFromInput(text);
                        },
                      ),
                    ),

                    const SizedBox(height: 80),

                    // The "Oracle" Button
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: vibeState.isLoading ? 0.5 : 1.0,
                      child: GestureDetector(
                        onTap: vibeState.isLoading ? null : _submit,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: vibeState.isLoading 
                              ? Text(
                                  'DIVINING...', 
                                  style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 4.0),
                                ) 
                              : Text(
                                  'CONSULT THE ORACLE',
                                  style: theme.textTheme.labelLarge,
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
