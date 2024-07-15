import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/data/repositories/order_repository_impl.dart';
import 'package:highty_inventory/domain/usecases/order.dart';
import 'package:highty_inventory/presentation/bloc/order_cubit.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:highty_inventory/presentation/screens/auth/login_screen.dart';
import 'package:highty_inventory/presentation/screens/order/order_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String displayName = '';

  @override
  void initState(){
    super.initState();
    _getDisplayName();
  }

  void _getDisplayName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('name') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = OrderRepositoryImpl();

    return BlocProvider(
      create: (context) => OrderCubit(FetchOrderUseCase(repository))..fetchOrder(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hi $displayName', style: primary20),
          actions: [
            IconButton(
              icon: Icon(Icons.logout_outlined),
              onPressed: () async {
                final supabase = Supabase.instance.client;
                try{
                  supabase.auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } catch (e){
                  log(e.toString());
                }
              }
            )
          ]
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ongoing Orders', style: primaryBold20),
              Expanded(
                child: BlocConsumer<OrderCubit, OrderState>(
                  listener: (context, state){
                    if(state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if(state.isLoading){
                      return Center(child: CircularProgressIndicator());
                    } else if (state.orderList != null && state.orderList!.isNotEmpty){
                      return ListView.builder(
                        itemCount: state.orderList!.length,
                        itemBuilder: (_, index) {
                          final order = state.orderList![index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => OrderDetail(orderId: order.orderId.toString())
                                )
                              );
                            },
                            child: Card(
                              child: ListTile(
                                leading: Image.asset(
                                  order.marketplace,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                  'Order ID: ${order.orderId}',
                                  style: primary14,
                                ),
                                subtitle: Text(order.status),
                                trailing: Icon(Icons.more_vert),
                              ),
                            ),
                          );
                        },
                      );
                    } else if(state.orderList!.isEmpty){
                      return  Center(child: Text("No orders today :'D"));
                    } else {
                      return Center(child: Text('No orders found'));
                    }
                    
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
