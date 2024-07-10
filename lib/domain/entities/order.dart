class Order {
  final String marketplace;
  final String orderId;
  final String status; 

  Order({required this.marketplace, required this.orderId, required this.status});
}

class OrderDetail {
  final String orderId;
  final String date;
  final List<Product> productList;

  OrderDetail({required this.orderId, required this.date, required this.productList});
}

class Product{
  final String nama;
  final String sku;
  final String imageLink;

  Product({required this.nama, required this.sku, required this.imageLink});
}


