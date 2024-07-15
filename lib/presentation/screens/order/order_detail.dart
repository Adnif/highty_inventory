import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highty_inventory/data/repositories/order_repository_impl.dart';
import 'package:highty_inventory/domain/entities/order.dart';
import 'package:highty_inventory/domain/entities/test.dart';
import 'package:highty_inventory/domain/usecases/order.dart';
import 'package:highty_inventory/presentation/bloc/order_cubit.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:highty_inventory/presentation/screens/order/qr_check.dart';

class OrderDetail extends StatefulWidget {
  final String orderId;

  const OrderDetail({required this.orderId, super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  @override
  Widget build(BuildContext context) {
    final repository = OrderRepositoryImpl();
    return BlocProvider(
      create: (context) => OrderDetailCubit(FetchOrderDetailUseCase(repository))..fetchOrderDetail(widget.orderId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.orderId}'
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<OrderDetailCubit, OrderDetailState>(
            listener: (context, state){
              if(state.errorMessage != null){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            },
            builder: (context, state) {
              if(state.isLoading){
                return Center(child: CircularProgressIndicator());
              } else if(state.orderDetail != null){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OrderDetails(
                          orderId: state.orderDetail!.orderId,
                          date: state.orderDetail!.date ?? 'Unknown',
                          resi: state.orderDetail!.resi ?? 'Unknown',
                        ),
                        ElevatedButton(
                          onPressed: (){
                            state.orderDetail!.resi != null
                            ? Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => QrCheck(receipt: state.orderDetail!.resi!, packageId: state.orderDetail!.packageId!,)
                                )
                              )
                            : Fluttertoast.showToast(msg: 'Resi belum ada');
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
                        itemCount: state.orderDetail!.productList!.length,
                        itemBuilder: (context, index) {
                          final finalProduct = state.orderDetail!.productList![index];
                          return ProductTile(product: finalProduct);
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
                );
              } else {
                return Center(child: Text('No details found'));
              }
              
            }
          ),
        ),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final String orderId;
  final String date;
  final String resi;

  OrderDetails({required this.orderId, required this.date, required this.resi});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Details', style: primaryBold20,),
        Text('Order ID: $orderId', style: primary,),
        Text('Date: $date', style: primary,),
        Text('Tracking Code: $resi', style: primary,),
      ],
    );
  }
}


class ProductTile extends StatelessWidget {
  final Product2 product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageLink),
        title: Text('SKU: ${product.sku}'),
        //subtitle: product.size != null ? Text('Size: ${product.size}') : null,
        //trailing: Text('x${product.quantity}'),
      ),
    );
  }
}