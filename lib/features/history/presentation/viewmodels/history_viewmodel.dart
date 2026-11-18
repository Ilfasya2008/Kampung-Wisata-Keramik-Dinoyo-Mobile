import 'package:flutter/foundation.dart';
import '../../domain/entities/history_era.dart';
import '../../domain/usecases/get_history_timeline.dart';

class HistoryViewModel extends ChangeNotifier {
  final GetHistoryTimeline getHistoryTimeline;

  HistoryViewModel({required this.getHistoryTimeline});

  int _selectedEraIndex = 0;

  int get selectedEraIndex => _selectedEraIndex;
  List<HistoryEra> get eras => getHistoryTimeline.execute();

  HistoryEra get currentEra => eras.isNotEmpty
      ? eras[_selectedEraIndex.clamp(0, eras.length - 1)]
      : eras.first;

  void selectEra(int index) {
    if (index >= 0 && index < eras.length) {
      _selectedEraIndex = index;
      notifyListeners();
    }
  }
}
