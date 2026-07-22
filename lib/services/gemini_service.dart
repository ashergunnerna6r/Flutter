import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey;
  late final GenerativeModel _model;

  GeminiService({required String apiKey}) : _apiKey = apiKey {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> translateText({
    required String text,
    required String targetLang,
  }) async {
    try {
      final prompt =
          'Translate the following chat message accurately into language code "$targetLang". Provide ONLY the direct translation string without quotes or notes:\n\n"$text"';
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ?? text;
    } catch (e) {
      print('Gemini Translation Error: $e');
      return text;
    }
  }

  Future<String> summarizeChat(List<String> messages) async {
    try {
      final chatData = messages.join('\n');
      final prompt =
          'Summarize the following chat messages concisely in 2-3 bullet points:\n\n$chatData';
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text?.trim() ?? 'No summary available.';
    } catch (e) {
      return 'Failed to generate summary: $e';
    }
  }
}
