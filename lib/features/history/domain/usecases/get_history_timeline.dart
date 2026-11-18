import '../entities/history_era.dart';
import '../repositories/history_repository.dart';

class GetHistoryTimeline {
  final HistoryRepository repository;
  GetHistoryTimeline(this.repository);

  List<HistoryEra> execute() => repository.getTimeline();
}
