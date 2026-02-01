import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? _base64Image;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Convert to Base64 immediately
      final bytes = await image.readAsBytes();
      final base64 = base64Encode(bytes);
      
      setState(() {
        _selectedImage = image;
        _base64Image = base64;
      });
    }
  }

  void _submit() async {
    if (_controller.text.isEmpty && _selectedImage == null) return;
    
    // Call the Vibe Engine (Text + Optional Image)
    ref.read(vibeProvider.notifier).analyzeVibe(
      _controller.text, 
      imageBase64: _base64Image
    );

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ResultsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vibeState = ref.watch(vibeProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: GenerativeScaffold(
        drawer: _buildDebugDrawer(context, theme),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // The Question
                    Text(
                      'Describe your Essence',
                      style: theme.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0),

                    const SizedBox(height: 60),

                    // The Input Row (Text + Camera)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: theme.textTheme.headlineSmall,
                            cursorColor: const Color(0xFFD4AF37),
                            decoration: InputDecoration.collapsed(
                              hintText: 'e.g., A rainy afternoon in London...',
                              hintStyle: theme.textTheme.headlineSmall?.copyWith(
                                color: const Color(0xFF1A1A1A).withOpacity(0.4),
                              ),
                            ),
                            onChanged: (text) {
                              ref.read(vibeProvider.notifier).updateVibeFromInput(text);
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // 📸 Camera Button
                        GestureDetector(
                          onTap: _pickImage,
                          child: AnimatedContainer(
                            duration: 300.ms,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _selectedImage != null 
                                  ? const Color(0xFFD4AF37) // Gold if selected
                                  : Colors.transparent,
                              border: Border.all(color: const Color(0xFFD4AF37)),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _selectedImage != null ? Icons.check : Icons.camera_alt_outlined,
                              color: _selectedImage != null ? Colors.white : const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Preview selected image (Tiny thumbnail)
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb 
                            ? Image.network(_selectedImage!.path, height: 60, width: 60, fit: BoxFit.cover)
                            : Image.file(File(_selectedImage!.path), height: 60, width: 60, fit: BoxFit.cover),
                        ).animate().scale(duration: 300.ms),
                      ),

                    const SizedBox(height: 80),

                    // The "Oracle" Button
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: vibeState.isLoading ? 0.5 : 1.0,
                      child: GestureDetector(
                        onTap: vibeState.isLoading ? null : _submit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF1A1A1A), width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: vibeState.isLoading 
                              ? Text(
                                  'DIVINING...', 
                                  style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 4.0),
                                ) 
                              : Text(
                                  'CONSULT THE ORACLE',
                                  style: theme.textTheme.labelLarge,
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

  Widget _buildDebugDrawer(BuildContext context, ThemeData theme) {
    return Drawer(
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
            leading: const Icon(Icons.science),
            title: Text('Test: Blind Date Reveal', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RevealScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}