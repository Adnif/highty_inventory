import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/domain/usecases/stock.dart';

class StockState {
  final bool isLoading;
  final String? errorMessage;
  final List<Map<String, String>>? stock;

  StockState({this.isLoading = false, this.errorMessage, this.stock});

  StockState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Map<String, String>>? stock,
  }) {
    return StockState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      stock: stock ?? this.stock,
    );
  }
}

class StockCubit extends Cubit<StockState> {
  final FetchStockUseCase fetchStockUseCase;
  List<Map<String, String>> allStocks = [];

  StockCubit(this.fetchStockUseCase) : super(StockState());

  Future<void> fetchStock(String category) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final stock = await fetchStockUseCase.fetch(category);
      if (stock != null) {
        allStocks = stock;
        emit(state.copyWith(isLoading: false, stock: stock));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'No stocks found'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'An error occurred: $e'));
    }
  }

  void filterStocks(String query) {
    final filteredStocks = allStocks.where((stock) {
      return stock['nama']!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(state.copyWith(stock: filteredStocks));
  }
}
