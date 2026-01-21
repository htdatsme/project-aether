import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/generative_theme.dart';
import 'core/theme/app_theme.dart';
import 'features/vibe_engine/vibe_controller.dart';
import 'features/vibe_engine/input_screen.dart';

void main() {
  runApp(const ProviderScope(child: ProjectAetherApp()));
}

class ProjectAetherApp extends ConsumerWidget {
  const ProjectAetherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the VibeController to retrieve the current VibeState
    final vibeState = ref.watch(vibeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Aether',
      // Enable smooth theme transitions
      themeAnimationDuration: const Duration(milliseconds: 800),
      themeAnimationCurve: Curves.easeInOut,
      theme: AppTheme.lightTheme.copyWith(
        extensions: [vibeState.theme],
      ),
      home: const InputScreen(),
    );
  }
}
