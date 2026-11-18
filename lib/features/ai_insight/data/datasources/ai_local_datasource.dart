import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_insight_model.dart';

abstract class AiLocalDataSource {
  List<AiInsightModel> getSavedInsights();
  Future<void> saveInsight(AiInsightModel insight);
  Future<void> deleteInsight(String id);
}

class AiLocalDataSourceImpl implements AiLocalDataSource {
  final SharedPreferences prefs;
  static const String _storageKey = 'dinoyo_saved_ai_insights';

  AiLocalDataSourceImpl(this.prefs);

  @override
  List<AiInsightModel> getSavedInsights() {
    final raw = prefs.getStringList(_storageKey) ?? [];
    return raw
        .map((str) {
          try {
            return AiInsightModel.fromJson(jsonDecode(str));
          } catch (_) {
            return null;
          }
        })
        .whereType<AiInsightModel>()
        .toList();
  }

  @override
  Future<void> saveInsight(AiInsightModel insight) async {
    final list = getSavedInsights();
    // Jika sudah ada id yang sama, hapus dulu
    list.removeWhere((i) => i.id == insight.id);
    list.insert(0, insight);

    final encoded = list.map((i) => jsonEncode(i.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  @override
  Future<void> deleteInsight(String id) async {
    final list = getSavedInsights();
    list.removeWhere((i) => i.id == id);
    final encoded = list.map((i) => jsonEncode(i.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }
}
