import 'package:highty_inventory/domain/entities/history.dart';
import 'package:highty_inventory/domain/repositories/history_repository.dart';


class FetchHistoryUseCase {
  final HistoryRepository repository;

  FetchHistoryUseCase(this.repository);

  Future<List<HistoryItem>?> fetch() {
    return repository.fetch();
  }
}