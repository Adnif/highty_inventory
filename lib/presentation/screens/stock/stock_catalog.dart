import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/data/repositories/stock_repository_impl.dart';
import 'package:highty_inventory/domain/usecases/stock.dart';
import 'package:highty_inventory/presentation/bloc/stock_bloc.dart';
import 'package:highty_inventory/presentation/constants/colors.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:highty_inventory/presentation/screens/stock/stock_detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StockCatalog extends StatelessWidget {
  final String category;
  //final StockRepository repository; // Pass the repository to the widget

  const StockCatalog({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;
    final repository = StockRepositoryImpl(supabaseClient);

    return BlocProvider(
      create: (context) => StockCubit(FetchStockUseCase(repository))..fetchStock(category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$category Stocks',
            style: primary,
          ),
        ),
        body: StockCatalogBody(),
      ),
    );
  }
}

class StockCatalogBody extends StatefulWidget {
  @override
  _StockCatalogBodyState createState() => _StockCatalogBodyState();
}

class _StockCatalogBodyState extends State<StockCatalogBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStocks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStocks() {
    context.read<StockCubit>().filterStocks(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<StockCubit, StockState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage!)),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.stock != null) {
                  final stocks = state.stock!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      final stock = stocks[index];
                      return StockItem(
                        sku: stock['SKU']!,
                        imagePath: stock['images']!, // Assuming you have a default image
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No stocks found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StockItem extends StatelessWidget {
  final String sku;
  final String imagePath;

  StockItem({required this.sku, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockDetailScreen(sku: sku, imageUrl: imagePath,),
          ),
        );
      },
      child: Card(
        color: kPrimaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                imagePath,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sku,
              style: primaryWhite,
            ),
          ],
        ),
      ),
    );
  }
}
