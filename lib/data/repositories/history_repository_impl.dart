import 'dart:convert';
import 'dart:developer';

import 'package:highty_inventory/domain/entities/history.dart';
import 'package:highty_inventory/domain/repositories/history_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final SupabaseClient supabase;

  HistoryRepositoryImpl(this.supabase);

  @override
  Future<List<HistoryItem>?> fetch() async {
    try {
      final response = await supabase
          .from('history')
          .select('created_at, nama, atribut');


      final data = response as List<dynamic>;

      final history = data.map((item) {
        return HistoryItem(
          item['nama'] as String,
          jsonEncode(item['atribut']),
          item['created_at'] as String,
        );
      }).toList();

      log('History: ${history[0].time}');

      return history;
    } catch (e) {
      log('Exception occurred while fetching history: $e');
      return null;
    }
  }
}
