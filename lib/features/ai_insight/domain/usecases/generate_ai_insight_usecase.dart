import '../entities/ai_insight.dart';
import '../repositories/ai_insight_repository.dart';

class GenerateAiInsight {
  final AiInsightRepository repository;
  GenerateAiInsight(this.repository);

  Future<AiInsight> execute(String userQuery, {String? apiKey}) async {
    final clean = userQuery.trim();
    if (clean.isEmpty) {
      throw ArgumentError('Permintaan insight tidak boleh kosong');
    }
    final insight = await repository.generateInsight(clean, apiKey: apiKey);
    await repository.saveInsight(insight);
    return insight;
  }
}
