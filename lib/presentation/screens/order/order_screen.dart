import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
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

  final List<Map<String, String>> dummyOrders = [
    {'receipt': 'knlt1', 'orderId': 'mmk1'},
    {'receipt': 'knlt2', 'orderId': 'mmk2'},
    {'receipt': 'knlt3', 'orderId': 'mmk3'},
    // Add more items if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi $displayName', style: primary20),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Outgoing Orders', style: primaryBold20),
            Expanded(
              child: ListView.builder(
                itemCount: dummyOrders.length,
                itemBuilder: (_, index) {
                  final order = dummyOrders[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => OrderDetail(receipt: order['receipt'].toString())
                        )
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt),
                        title: Text(
                          'Receipt: ${order['receipt']}\nOrder ID: ${order['orderId']}',
                          style: primary14,
                        ),
                        subtitle: const Row(
                          children: [
                            Icon(Icons.local_shipping),
                            Icon(Icons.access_time),
                          ],
                        ),
                        trailing: Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
