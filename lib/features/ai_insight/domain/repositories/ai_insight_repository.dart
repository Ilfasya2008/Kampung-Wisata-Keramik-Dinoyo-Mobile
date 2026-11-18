import '../entities/ai_insight.dart';

abstract class AiInsightRepository {
  Future<AiInsight> generateInsight(String userQuery, {String? apiKey});
  List<AiInsight> getSavedInsights();
  Future<void> saveInsight(AiInsight insight);
  Future<void> deleteInsight(String id);
}
