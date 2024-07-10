import 'package:highty_inventory/domain/entities/history.dart';

abstract class HistoryRepository{
  Future<List<HistoryItem>?> fetch();
}