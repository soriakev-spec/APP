abstract class AiService {
  bool get isAvailable;
  String get providerName;

  Future<String> expandPhrase(String input, {String? profileContext, String language = 'es-MX'});
  Future<List<String>> suggestNextWords(List<String> currentWords, {String? profileContext});
  Future<String> generateSocialStory(String situation, String name, {String diagnosis = 'autism'});
  Future<List<Map<String, dynamic>>> generateBoardVocabulary(String topic, int count, {String? profileDiagnosis});
  Future<String> generateRoutine(String activity, int steps, {String ageGroup = 'child'});
  Future<List<String>> detectMissingVocabulary(List<String> currentVocab, String profileDiagnosis);
  Future<String> translatePhrase(String text, String targetLanguage);
  Future<String> adaptForAge(String text, String ageGroup);
  Future<List<String>> generateActivityQuestions(String topic, int count, String activityType);
  Future<List<String>> getTherapistRecommendations(Map<String, dynamic> usageData, String diagnosis);
}

class StubAiService implements AiService {
  @override
  bool get isAvailable => false;

  @override
  String get providerName => 'Sin IA configurada';

  @override
  Future<String> expandPhrase(String input, {String? profileContext, String language = 'es-MX'}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return '$input (conectar IA para expandir)';
  }

  @override
  Future<List<String>> suggestNextWords(List<String> currentWords, {String? profileContext}) async {
    return ['quiero', 'más', 'ayuda'];
  }

  @override
  Future<String> generateSocialStory(String situation, String name, {String diagnosis = 'autism'}) async {
    return 'Historia social sobre "$situation" para $name.\n\n[Conectar Claude/OpenAI para generar historia social personalizada]';
  }

  @override
  Future<List<Map<String, dynamic>>> generateBoardVocabulary(String topic, int count, {String? profileDiagnosis}) async {
    return List.generate(count, (i) => {
      'label': 'Palabra ${i + 1}',
      'category': topic,
      'fitzgerald': 'nouns',
    });
  }

  @override
  Future<String> generateRoutine(String activity, int steps, {String ageGroup = 'child'}) async {
    return 'Rutina de "$activity" en $steps pasos.\n\n[Conectar IA para rutina personalizada]';
  }

  @override
  Future<List<String>> detectMissingVocabulary(List<String> currentVocab, String profileDiagnosis) async {
    return ['[Conectar IA para detectar vocabulario faltante]'];
  }

  @override
  Future<String> translatePhrase(String text, String targetLanguage) async {
    return '$text [traducción a $targetLanguage requiere IA]';
  }

  @override
  Future<String> adaptForAge(String text, String ageGroup) async {
    return '$text [adaptado para $ageGroup]';
  }

  @override
  Future<List<String>> generateActivityQuestions(String topic, int count, String activityType) async {
    return List.generate(count, (i) => 'Pregunta ${i + 1} sobre $topic');
  }

  @override
  Future<List<String>> getTherapistRecommendations(Map<String, dynamic> usageData, String diagnosis) async {
    return ['[Conectar IA para recomendaciones terapéuticas personalizadas]'];
  }
}

class ClaudeAiService implements AiService {
  final String apiKey;
  ClaudeAiService({required this.apiKey});

  @override
  bool get isAvailable => apiKey.isNotEmpty;

  @override
  String get providerName => 'Claude (Anthropic)';

  // TODO: Implement HTTP calls to https://api.anthropic.com/v1/messages
  // Model: claude-sonnet-4-6 or claude-haiku-4-5-20251001 for speed
  // Use --dart-define=CLAUDE_API_KEY=... for key injection

  @override
  Future<String> expandPhrase(String input, {String? profileContext, String language = 'es-MX'}) async {
    throw UnimplementedError('Implementar llamada a Claude API');
  }

  @override
  Future<List<String>> suggestNextWords(List<String> currentWords, {String? profileContext}) async {
    throw UnimplementedError();
  }

  @override
  Future<String> generateSocialStory(String situation, String name, {String diagnosis = 'autism'}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> generateBoardVocabulary(String topic, int count, {String? profileDiagnosis}) async {
    throw UnimplementedError();
  }

  @override
  Future<String> generateRoutine(String activity, int steps, {String ageGroup = 'child'}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> detectMissingVocabulary(List<String> currentVocab, String profileDiagnosis) async {
    throw UnimplementedError();
  }

  @override
  Future<String> translatePhrase(String text, String targetLanguage) async {
    throw UnimplementedError();
  }

  @override
  Future<String> adaptForAge(String text, String ageGroup) async {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> generateActivityQuestions(String topic, int count, String activityType) async {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getTherapistRecommendations(Map<String, dynamic> usageData, String diagnosis) async {
    throw UnimplementedError();
  }
}
