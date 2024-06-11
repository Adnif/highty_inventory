import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks Category'),
        elevation: 0,
        titleTextStyle: primaryBold20,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [

          ],
        )
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath){
    return GestureDetector(
      onTap: (){

      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.5)
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: primaryWhite,
            ),
          )
        ],
      )
    );
  }
}