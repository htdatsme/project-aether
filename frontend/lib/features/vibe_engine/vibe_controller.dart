import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/generative_theme.dart';
import 'package:flutter/foundation.dart';

class VibeState {
  final GenerativeTheme theme;
  final bool isLoading;
  final Map<String, dynamic>? analysisResult;

  VibeState({
    required this.theme,
    this.isLoading = false,
    this.analysisResult,
  });

  VibeState copyWith({
    GenerativeTheme? theme,
    bool? isLoading,
    Map<String, dynamic>? analysisResult,
  }) {
    return VibeState(
      theme: theme ?? this.theme,
      isLoading: isLoading ?? this.isLoading,
      analysisResult: analysisResult ?? this.analysisResult,
    );
  }
}

class VibeController extends Notifier<VibeState> {
  @override
  VibeState build() => VibeState(theme: GenerativeTheme.champagne());

  void setChampagne() {
    state = state.copyWith(theme: GenerativeTheme.champagne());
  }

  void setRose() {
    state = state.copyWith(theme: GenerativeTheme.rose());
  }

  void setTeal() {
    state = state.copyWith(
      theme: GenerativeTheme(
        vibeStartColor: const Color(0xFFE0F7FA), // Light Cyan
        vibeEndColor: const Color(0xFF006064), // Cyan 900
        goldAccent: const Color(0xFF00BCD4),
        physicsGravity: 0.1,
        blurSigma: 15.0,
      ),
    );
  }

  void setAmber() {
    state = state.copyWith(
      theme: GenerativeTheme(
        vibeStartColor: const Color(0xFFFFF8E1), // Amber 50
        vibeEndColor: const Color(0xFFFF6F00), // Amber 900
        goldAccent: const Color(0xFFFFC107),
        physicsGravity: 0.3,
        blurSigma: 12.0,
      ),
    );
  }

  void updateVibeFromInput(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('rain')) {
      setTeal();
    } else if (lower.contains('oud')) {
      setAmber();
    }
  }

  Future<void> analyzeVibe(String text) async {
    state = state.copyWith(isLoading: true);
    
    // Simulate network delay for "breathing" animation observation if needed
    // await Future.delayed(const Duration(seconds: 2));

    try {
      // Production API URL - Google Cloud Run
      const String baseUrl = 'https://aether-brain-937286023670.us-central1.run.app';

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/analyze-vibe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(isLoading: false, analysisResult: data);
      } else {
        print('VIBE ENGINE ERROR: ${response.statusCode}');
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      print('VIBE ENGINE EXCEPTION: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  void logGroundTruth() {
    // Mimic sending a "Verified Match"
    // In a real app, we would pass the Scent ID and User Session
    print("DATA MOAT: Captured verified preference for Scent ID: [UUID-MOCK-1234]");
  }
}

final vibeProvider = NotifierProvider<VibeController, VibeState>(VibeController.new);
