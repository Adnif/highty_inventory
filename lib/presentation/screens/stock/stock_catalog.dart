import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/colors.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:highty_inventory/presentation/screens/stock/stock_detail.dart';

class StockCatalog extends StatefulWidget {
  final String category;

  const StockCatalog({required this.category, super.key});

  @override
  State<StockCatalog> createState() => _StockCatalogState();
}

class _StockCatalogState extends State<StockCatalog> {

  final List<Map<String, String>> stocks = [
    {'sku': 'KTS30', 'image': 'assets/150x150.png'},
    {'sku': 'KTS31', 'image': 'assets/150x150.png'},
    {'sku': 'KTS36', 'image': 'assets/150x150.png'},
    {'sku': 'KTS24', 'image': 'assets/150x150.png'},
    {'sku': 'KTS34', 'image': 'assets/150x150.png'},
    {'sku': 'KTS17', 'image': 'assets/150x150.png'},
  ];

  List<Map<String, String>> _filteredStocks = [];

  final TextEditingController _searchController = TextEditingController();

  void initState() {
    super.initState();
    _filteredStocks = stocks; // Initially display all stocks
    _searchController.addListener(_filterStocks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStocks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStocks = stocks.where((stock) {
        final skuLower = stock['sku']!.toLowerCase();
        return skuLower.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category} Stocks',
          style: primary,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search by SKU...',
                  prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _filteredStocks.length,
                itemBuilder: (context, index) {
                  final stock = _filteredStocks[index];
                  return StockItem(
                    sku: stock['sku']!,
                    imagePath: stock['image']!,
                  );
                },
              ),
            )
          ],
        )
      )
    );
  }
}

class StockItem extends StatelessWidget{
    final String sku;
    final String imagePath;

    StockItem({required this.sku, required this.imagePath});

    @override
    Widget build(BuildContext context){
      return GestureDetector(
        onTap: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => StockDetail(sku: sku)
            )
          );
        },
        child: Card(
          color: kPrimaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                sku,
                style: primaryWhite,
              )
            ],
          ),
        ),
      );
    }
    
    
}