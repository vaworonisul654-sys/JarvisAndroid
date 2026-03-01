import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:jarvis_voice_system/models/learner_profile.dart';
import 'package:jarvis_voice_system/services/gemini_service.dart';
import 'package:jarvis_voice_system/services/audio_service.dart';
import 'package:jarvis_voice_system/services/tts_service.dart';

class MentorProvider with ChangeNotifier {
  final GeminiService gemini = GeminiService();
  final AudioService audio = AudioService();
  final TTSService tts = TTSService();
  
  LearnerProfile profile = LearnerProfile();
  bool isRecording = false;
  String currentStatus = "Ready to speak";
  String transcript = "";

  Future<void> init(String apiKey) async {
    await audio.init();
    await tts.init();
    await gemini.connect(apiKey);
    
    gemini.messages.listen((msg) {
      _handleGeminiMessage(msg);
    });
  }

  void _handleGeminiMessage(Map<String, dynamic> msg) {
    if (msg.containsKey('serverContent')) {
      final content = msg['serverContent'];
      if (content.containsKey('modelTurn')) {
        final parts = content['modelTurn']['parts'];
        for (var part in parts) {
          if (part.containsKey('text')) {
            transcript = part['text'];
            notifyListeners();
          }
          if (part.containsKey('inlineData')) {
            final audioData = base64Decode(part['inlineData']['data']);
            tts.playChunk(audioData);
          }
        }
      }
    }
  }

  Future<void> toggleRecording() async {
    if (isRecording) {
      await audio.stopCapture();
      currentStatus = "Thinking...";
    } else {
      try {
        final stream = await audio.startCapture();
        currentStatus = "Listening...";
        stream.listen((chunk) {
          gemini.sendAudioChunk(chunk);
        });
      } catch (e) {
        currentStatus = "Error: $e";
      }
    }
    isRecording = !isRecording;
    notifyListeners();
  }

  @override
  void dispose() {
    audio.dispose();
    tts.dispose();
    gemini.dispose();
    super.dispose();
  }
}
