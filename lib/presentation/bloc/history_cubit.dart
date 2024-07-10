import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/entities/history.dart';
import 'package:highty_inventory/domain/usecases/history.dart';

class HistoryState {
  final bool isLoading;
  final String? errorMessage;
  final List<HistoryItem>? history;

  HistoryState({this.isLoading = false, this.errorMessage, this.history});

  HistoryState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<HistoryItem>? history,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      history: history ?? this.history,
    );
  }
}

class HistoryCubit extends Cubit<HistoryState> {
  final FetchHistoryUseCase fetchHistoryUseCase;
  List<HistoryItem?> allHistories = [];

  HistoryCubit(this.fetchHistoryUseCase) : super(HistoryState());

  Future<void> fetchHistory() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final history = await fetchHistoryUseCase.fetch();
      if(isClosed) return;
      if (history!= null) {
        allHistories = history;
        emit(state.copyWith(isLoading: false, history: history));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'No stocks found'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occurred: $e'));
    }
  }

  // void filterStocks(String query) {
  //   final filteredStocks = allStocks.where((stock) {
  //     return stock['nama']!.toLowerCase().contains(query.toLowerCase());
  //   }).toList();
  //   emit(state.copyWith(stock: filteredStocks));
  // }
}
