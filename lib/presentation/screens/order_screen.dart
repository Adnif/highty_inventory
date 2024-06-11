import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi {Username}', style: primary20),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 26.0),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Outgoing Orders', style: primaryBold20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (_, index){
                        final list = [];
                        // Make sure your list has at least 3 items to avoid an out-of-bounds error.
                        if (index >= list.length) {
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.abc),
                              title: Text(
                                'Receipt: knlt\nOrder ID: mmk',
                                style: primary14,
                              ),
                              subtitle: const Row(
                                children: [
                                  Icon(Icons.abc),
                                  Icon(Icons.abc)
                                ],
                              ),
                              trailing: Icon(Icons.abc),
                            ),
                          );
                        }
                        final item = list[index];
                        // Your actual list item widget goes here
                        return const Card(
                          child: ListTile(
                            leading: Icon(Icons.abc),
                            title: Text('Receipt: knlt\nOrder ID: mmk'),
                            subtitle: Row(
                              children: [
                                Icon(Icons.abc),
                                Icon(Icons.abc)
                              ],
                            ),
                            trailing: Icon(Icons.abc),
                          ),
                        );
                      }
                    ),
                  ),
                ],
              )
      )
    );
  }
}