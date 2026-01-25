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
      // Improved Base URL logic: works on Web, Mobile, and Prod
      String baseUrl = const String.fromEnvironment('API_URL');
      if (baseUrl.isEmpty) {
        if (kIsWeb) {
          baseUrl = 'http://localhost:8000';
        } else {
          // Android Emulator default gateway
          baseUrl = 'http://10.0.2.2:8000';
        }
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/analyze-vibe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Dynamic Theme Application
        GenerativeTheme? newTheme;
        if (data['theme_colors'] != null && data['theme_colors'] is List && data['theme_colors'].length >= 2) {
          try {
            final startColor = _parseHexColor(data['theme_colors'][0]);
            final endColor = _parseHexColor(data['theme_colors'][1]);
            newTheme = GenerativeTheme(
              vibeStartColor: startColor,
              vibeEndColor: endColor,
              goldAccent: const Color(0xFFD4AF37),
              physicsGravity: 0.2,
              blurSigma: 12.0,
            );
          } catch (e) {
            print("COLOR PARSE ERROR: $e");
          }
        }

        state = state.copyWith(
          isLoading: false, 
          analysisResult: data,
          theme: newTheme ?? state.theme, // Apply new theme or keep current if parsing failed
        );
      } else {
        print('VIBE ENGINE ERROR: ${response.statusCode}');
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      print('VIBE ENGINE EXCEPTION: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Color _parseHexColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Future<void> revealScent(String scentId, String userVibe) async {
      try {
        const String baseUrl = String.fromEnvironment(
        'API_URL', 
        defaultValue: 'http://127.0.0.1:8000'
      );

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/blind-date-reveal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'scent_id': scentId,
          'user_vibe_description': userVibe
        }),
      );

      if (response.statusCode == 200) {
        print("DATA MOAT: Successfully logged reveal for $scentId");
      } else {
        print("DATA MOAT ERROR: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("DATA MOAT EXCEPTION: $e");
    }
  }

  void logGroundTruth() {
    // Legacy/Mock function - kept for compatibility if needed, but should effectively route to revealScent if data is available
    if (state.analysisResult != null) {
       final scentId = state.analysisResult!['scent_id'];
       final reason = state.analysisResult!['match_reason'] ?? "Unknown Vibe";
       
       if (scentId != null) {
          revealScent(scentId, reason);
       } else {
         print("DATA MOAT WARNING: No Scent ID available to log.");
       }
    }
  }
}

final vibeProvider = NotifierProvider<VibeController, VibeState>(VibeController.new);