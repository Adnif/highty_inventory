import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:highty_inventory/presentation/screens/order/qr_check.dart';

class OrderDetail extends StatefulWidget {
  final String receipt;

  const OrderDetail({required this.receipt, super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  final List<Product> productList = [
    Product(image: 'assets/150x150.png', sku: 'SR11', size: 'S', quantity: 1),
    Product(image: 'assets/150x150.png', sku: 'CAP05', size: '29', quantity: 1),
    Product(image: 'assets/150x150.png', sku: 'ELF02', quantity: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.receipt}'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrderDetails(
                  orderId: 'XXXX2',
                  date: '10 Mar 24',
                  receipt: 'XXXX2R',
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => QrCheck(receipt: widget.receipt,)
                      )
                    );
                  },
                  child: Icon(Icons.qr_code),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    //backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    
                  ),
                )
              ],
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return ProductTile(product: product);
                },
              ),
            ),
            const SizedBox(height: 16,),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor:  Colors.red,
                  backgroundColor: Colors.red,

                ),
                onPressed: (){

                },
                child: Text(
                  'Reject Order',
                  style: primaryWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final String orderId;
  final String date;
  final String receipt;

  OrderDetails({required this.orderId, required this.date, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Details', style: primaryBold20,),
        Text('Order ID: $orderId', style: primary,),
        Text('Date: $date', style: primary,),
        Text('Receipt: $receipt', style: primary,),
      ],
    );
  }
}

class Product {
  final String image;
  final String sku;
  final String? size;
  final int quantity;

  Product({
    required this.image,
    required this.sku,
    this.size,
    required this.quantity,
  });
}

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(product.image),
        title: Text('SKU: ${product.sku}'),
        subtitle: product.size != null ? Text('Size: ${product.size}') : null,
        trailing: Text('x${product.quantity}'),
      ),
    );
  }
}