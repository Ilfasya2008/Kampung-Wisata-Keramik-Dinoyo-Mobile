import '../entities/history_era.dart';

abstract class HistoryRepository {
  List<HistoryEra> getTimeline();
  HistoryEra? getEraById(String id);
}
