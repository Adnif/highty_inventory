
import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<HistoryItem> historyItems = [
    HistoryItem('Supplier 1 updated stock!', 'KTS30 L (+11)\nKTS30 M (+10)', '3h'),
    HistoryItem('Supplier 2 updated stock!', 'KTS30 S (+7)\nKTS30 M (-10)', '4h'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History', style: primary),
      ),
      body: ListView.builder(
        itemCount: historyItems.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
            child: Card(
              child: ListTile(
                title: Text(historyItems[index].title),
                subtitle: Text(historyItems[index].description),
                trailing: Text(historyItems[index].time),
              ),
            ),
          );
        }
      )
    );
  }
}

class HistoryItem {
  final String title;
  final String description;
  final String time;

  HistoryItem(this.title, this.description, this.time);
}