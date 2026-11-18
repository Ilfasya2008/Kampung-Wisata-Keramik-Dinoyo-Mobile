import '../repositories/ai_insight_repository.dart';

class DeleteAiInsight {
  final AiInsightRepository repository;
  DeleteAiInsight(this.repository);

  Future<void> execute(String id) async {
    await repository.deleteInsight(id);
  }
}
