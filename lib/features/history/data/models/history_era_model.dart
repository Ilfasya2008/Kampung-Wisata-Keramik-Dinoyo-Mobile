import '../../domain/entities/history_era.dart';

class HistoryEraModel extends HistoryEra {
  const HistoryEraModel({
    required super.id,
    required super.chip,
    required super.period,
    required super.title,
    required super.description,
    required super.culturalSignificance,
    required super.imageAsset,
    required super.keyMilestones,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'chip': chip,
        'period': period,
        'title': title,
        'description': description,
        'culturalSignificance': culturalSignificance,
        'imageAsset': imageAsset,
        'keyMilestones': keyMilestones,
      };

  factory HistoryEraModel.fromJson(Map<String, dynamic> json) =>
      HistoryEraModel(
        id: json['id'] ?? '',
        chip: json['chip'] ?? '',
        period: json['period'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        culturalSignificance: json['culturalSignificance'] ?? '',
        imageAsset: json['imageAsset'] ?? 'assets/images/history_1930.jpg',
        keyMilestones: (json['keyMilestones'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

  HistoryEra toDomain() => HistoryEra(
        id: id,
        chip: chip,
        period: period,
        title: title,
        description: description,
        culturalSignificance: culturalSignificance,
        imageAsset: imageAsset,
        keyMilestones: keyMilestones,
      );
}
