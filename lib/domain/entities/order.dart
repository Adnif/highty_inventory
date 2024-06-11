class Order {
  final String receipt;
  final String orderId;
  final String status;
  final List<String> items;
  final String logoUrl;

  Order({
    required this.receipt,
    required this.orderId,
    required this.status,
    required this.items,
    required this.logoUrl,
  });
}
