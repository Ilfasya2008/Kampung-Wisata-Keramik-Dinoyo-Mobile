import '../entities/ai_insight.dart';
import '../repositories/ai_insight_repository.dart';

class GetSavedInsights {
  final AiInsightRepository repository;
  GetSavedInsights(this.repository);

  List<AiInsight> execute() => repository.getSavedInsights();
}
