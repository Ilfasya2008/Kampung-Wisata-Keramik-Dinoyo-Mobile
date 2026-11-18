class AiInsight {
  final String id;
  final String title;
  final String category;
  final String ceramicRecommendation;
  final String culturalSignificance;
  final String estimatedBudget;
  final String careTips;
  final List<String> recommendedShops;
  final List<String> keyPoints;
  final DateTime createdAt;
  final String rawJson;

  const AiInsight({
    required this.id,
    required this.title,
    required this.category,
    required this.ceramicRecommendation,
    required this.culturalSignificance,
    required this.estimatedBudget,
    required this.careTips,
    required this.recommendedShops,
    required this.keyPoints,
    required this.createdAt,
    required this.rawJson,
  });
}
