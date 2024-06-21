class StockDetail {
  final String nama;
  final List<int> stock;
  final List<String> size;

  StockDetail({required this.nama, required this.stock, required this.size});
}

class UpdateStock {
  final List<int> stock;
  final List<String> size;
  final String nama;

  UpdateStock({required this.stock, required this.size, required this.nama});
}