class Product2 {
  final String sku;
  String? name;
  Map<String, dynamic>? stock;
  final String imageLink;
  String? staffName;

  Product2({required this.sku, this.name, this.stock, required this.imageLink, this.staffName});
}

// class Order2 {
//   final String orderId;
//   final List<Product2> product;
//   final String resi;
//   String? staffName;

//   Order2({required this.orderId, required this.product, required this.resi});
// }
