import 'package:flutter/foundation.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/usecases/delete_ai_insight_usecase.dart';
import '../../domain/usecases/generate_ai_insight_usecase.dart';
import '../../domain/usecases/get_saved_insights_usecase.dart';

class AiInsightViewModel extends ChangeNotifier {
  final GenerateAiInsight generateAiInsight;
  final GetSavedInsights getSavedInsights;
  final DeleteAiInsight deleteAiInsight;

  AiInsightViewModel({
    required this.generateAiInsight,
    required this.getSavedInsights,
    required this.deleteAiInsight,
  });

  AiInsight? _currentInsight;
  bool _isLoading = false;
  String? _errorMessage;
  String _geminiApiKey = '';

  AiInsight? get currentInsight => _currentInsight;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get geminiApiKey => _geminiApiKey;
  List<AiInsight> get savedInsights => getSavedInsights.execute();

  void setApiKey(String key) {
    _geminiApiKey = key.trim();
    notifyListeners();
  }

  void selectInsight(AiInsight insight) {
    _currentInsight = insight;
    notifyListeners();
  }

  Future<bool> askCurator(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await generateAiInsight.execute(
        query,
        apiKey: _geminiApiKey.isNotEmpty ? _geminiApiKey : null,
      );
      _currentInsight = result;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ArgumentError catch (e) {
      _errorMessage = e.message?.toString() ?? 'Permintaan tidak valid';
    } catch (e) {
      _errorMessage = 'Gagal memproses insight: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> removeInsight(String id) async {
    await deleteAiInsight.execute(id);
    if (_currentInsight?.id == id) {
      _currentInsight = null;
    }
    notifyListeners();
  }
}
