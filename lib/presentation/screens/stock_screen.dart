import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:highty_inventory/presentation/screens/stock_catalog.dart';

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
        title: const Text('Stocks Category'),
        elevation: 0,
        titleTextStyle: primaryBold20,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCategoryCard('Tops', 'assets/stocks/tops.png'),
            _buildCategoryCard('Footwear', 'assets/stocks/footwear.png'),
            _buildCategoryCard('Hats', 'assets/stocks/hats.png'),
            _buildCategoryCard('Pants', 'assets/stocks/pants.png'),
          ],
        )
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => StockCatalog(category: title)
          )
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.5)
            ),
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: primaryWhite,
              ),
            ),
          )
        ],
      )
    );
  }
}