import '../../../../core/services/gemini_ai_service.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/repositories/ai_insight_repository.dart';
import '../datasources/ai_local_datasource.dart';
import '../models/ai_insight_model.dart';

class AiInsightRepositoryImpl implements AiInsightRepository {
  final GeminiAiService geminiService;
  final AiLocalDataSource localDataSource;

  AiInsightRepositoryImpl({
    required this.geminiService,
    required this.localDataSource,
  });

  @override
  Future<AiInsight> generateInsight(String userQuery, {String? apiKey}) async {
    final response = await geminiService.generateInsight(
      query: userQuery,
      apiKey: apiKey,
    );

    final insightModel = AiInsightModel(
      id: 'insight_${DateTime.now().millisecondsSinceEpoch}',
      title: response.title,
      category: response.category,
      ceramicRecommendation: response.ceramicRecommendation,
      culturalSignificance: response.culturalSignificance,
      estimatedBudget: response.estimatedBudget,
      careTips: response.careTips,
      recommendedShops: response.recommendedShops,
      keyPoints: response.keyPoints,
      createdAt: DateTime.now(),
      rawJson: response.rawJson,
    );

    return insightModel.toDomain();
  }

  @override
  List<AiInsight> getSavedInsights() {
    return localDataSource.getSavedInsights().map((m) => m.toDomain()).toList();
  }

  @override
  Future<void> saveInsight(AiInsight insight) async {
    await localDataSource.saveInsight(AiInsightModel.fromDomain(insight));
  }

  @override
  Future<void> deleteInsight(String id) async {
    await localDataSource.deleteInsight(id);
  }
}
