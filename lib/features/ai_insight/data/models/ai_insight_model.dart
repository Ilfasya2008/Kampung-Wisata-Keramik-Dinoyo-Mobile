import '../../domain/entities/ai_insight.dart';

class AiInsightModel extends AiInsight {
  const AiInsightModel({
    required super.id,
    required super.title,
    required super.category,
    required super.ceramicRecommendation,
    required super.culturalSignificance,
    required super.estimatedBudget,
    required super.careTips,
    required super.recommendedShops,
    required super.keyPoints,
    required super.createdAt,
    required super.rawJson,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'ceramic_recommendation': ceramicRecommendation,
        'cultural_significance': culturalSignificance,
        'estimated_budget': estimatedBudget,
        'care_tips': careTips,
        'recommended_shops': recommendedShops,
        'key_points': keyPoints,
        'created_at': createdAt.toIso8601String(),
        'raw_json': rawJson,
      };

  factory AiInsightModel.fromJson(Map<String, dynamic> json) => AiInsightModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        category: json['category'] ?? '',
        ceramicRecommendation: json['ceramic_recommendation'] ?? '',
        culturalSignificance: json['cultural_significance'] ?? '',
        estimatedBudget: json['estimated_budget'] ?? '',
        careTips: json['care_tips'] ?? '',
        recommendedShops: (json['recommended_shops'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        keyPoints: (json['key_points'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        rawJson: json['raw_json'] ?? '',
      );

  AiInsight toDomain() => AiInsight(
        id: id,
        title: title,
        category: category,
        ceramicRecommendation: ceramicRecommendation,
        culturalSignificance: culturalSignificance,
        estimatedBudget: estimatedBudget,
        careTips: careTips,
        recommendedShops: recommendedShops,
        keyPoints: keyPoints,
        createdAt: createdAt,
        rawJson: rawJson,
      );

  factory AiInsightModel.fromDomain(AiInsight i) => AiInsightModel(
        id: i.id,
        title: i.title,
        category: i.category,
        ceramicRecommendation: i.ceramicRecommendation,
        culturalSignificance: i.culturalSignificance,
        estimatedBudget: i.estimatedBudget,
        careTips: i.careTips,
        recommendedShops: i.recommendedShops,
        keyPoints: i.keyPoints,
        createdAt: i.createdAt,
        rawJson: i.rawJson,
      );
}
