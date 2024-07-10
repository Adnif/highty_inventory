import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/data/repositories/stock_detail_repository_impl.dart';
import 'package:highty_inventory/data/repositories/stock_repository_impl.dart';
import 'package:highty_inventory/data/repositories/test_repository_impl.dart';
import 'package:highty_inventory/domain/entities/stock.dart';
import 'package:highty_inventory/domain/entities/test.dart';
import 'package:highty_inventory/domain/usecases/stock.dart';
import 'package:highty_inventory/domain/usecases/test.dart';
import 'package:highty_inventory/presentation/bloc/stock_detail_cubit.dart';
import 'package:highty_inventory/presentation/bloc/test_cubit.dart';
import 'package:highty_inventory/presentation/bloc/update_stock_cubit.dart';
import 'package:highty_inventory/presentation/constants/colors.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const double kPadding = 16.0;
const double kIconSize = 24.0;
const double kImageWidth = 150.0;

class StockDetailScreen extends StatelessWidget {
  final String sku;
  final String imageUrl;

  const StockDetailScreen({required this.sku, required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;
    final repository = StockRepository2Impl(supabaseClient);
    final updateRepository = UpdateStockRepositoryImpl(supabaseClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          //create: (context) => StockDetailCubit(FetchStockDetailUseCase(detailRepository))..fetchStockDetail(sku),
          create: (context) => StockCubit2(FetchStockUseCase2(repository))..fetchDetail(sku),
        ),
        BlocProvider(
          create: (context) => UpdateStockCubit(updateRepository),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(
            color: kAccentColor,
          ),
          title: Text(
            sku,
            style: primaryWhite,
          ),
        ),
        body: StockDetailBody(imageUrl: imageUrl),
      ),
    );
  }
}

class StockDetailBody extends StatelessWidget {
  final String imageUrl;

  const StockDetailBody({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StockCubit2, StockState2>(
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
        } else if (state.product != null) {
          final stockDetail = state.product!;
          return StockDetailContent(stockDetail: stockDetail, imageUrl: imageUrl);
        } else {
          return Center(child: Text('No stock detail found'));
        }
      },
    );
  }
}

class StockDetailContent extends StatefulWidget {
  final Product2 stockDetail;
  final String imageUrl;

  const StockDetailContent({required this.stockDetail, required this.imageUrl, Key? key}) : super(key: key);

  @override
  State<StockDetailContent> createState() => _StockDetailContentState();
}

class _StockDetailContentState extends State<StockDetailContent> {
  late List<int> stock;
  late List<String> size;
  late List<int> initialStock;
  bool isModified = false;

  @override
  void initState() {
    super.initState();
    stock = List.from(widget.stockDetail.stock!.values.toList());
    size = List.from(widget.stockDetail.stock!.keys.toList());
    initialStock = List.from(stock);
  }

  void checkIfModified() {
    setState(() {
      isModified = !listEquals(stock, initialStock);
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.imageUrl;
    return BlocConsumer<UpdateStockCubit, UpdateStockState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stock updated successfully')),
          );
          setState(() {
            initialStock = List.from(stock); // Reset initial stock
            isModified = false; // Reset modified flag
          });
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(imageUrl),
              const SizedBox(height: kPadding),
              _buildStockList(),
              ElevatedButton(
                onPressed: isModified
                    ? () {
                        final oldStock = UpdateStock(stock: initialStock, size: size, nama: widget.stockDetail.name);
                        final newStock = UpdateStock(size: size, stock: stock, nama: widget.stockDetail.name);
                        context.read<UpdateStockCubit>().updateStock(newStock, oldStock);                      
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    isModified ? kPrimaryColor : Colors.grey,
                  ),
                ),
                child: Text(
                  'Update Stock',
                  style: isModified ? primaryWhite : primaryDarkGrey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String imageUrl) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: kPadding / 2),
          Text(
            widget.stockDetail.name!,
            style: primaryWhite20,
          ),
          Text(
            '${stock.reduce((a, b) => a + b)}',
            style: primaryWhite20,
          ),
        ],
      ),
    );
  }

  Widget _buildStockList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stock.length,
      itemBuilder: (context, index) {
        return StockItem(
          size: size[index],
          stock: stock[index],
          onIncrease: () {
            setState(() {
              stock[index]++;
              checkIfModified();
            });
          },
          onDecrease: () {
            setState(() {
              if (stock[index] > 0) {
                stock[index]--;
                checkIfModified();
              }
            });
          },
        );
      },
    );
  }
}

class StockItem extends StatelessWidget {
  final String size;
  final int stock;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const StockItem({
    required this.size,
    required this.stock,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPadding / 2, horizontal: kPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            size,
            style: primary24,
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, size: kIconSize),
                onPressed: onDecrease,
              ),
              Text('$stock', style: primary24),
              IconButton(
                icon: const Icon(Icons.add_circle, size: kIconSize),
                onPressed: onIncrease,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
