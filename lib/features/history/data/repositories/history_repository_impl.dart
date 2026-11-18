import '../../domain/entities/history_era.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl(this.localDataSource);

  @override
  List<HistoryEra> getTimeline() {
    return localDataSource.getHistoryTimeline().map((m) => m.toDomain()).toList();
  }

  @override
  HistoryEra? getEraById(String id) {
    try {
      return getTimeline().firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
