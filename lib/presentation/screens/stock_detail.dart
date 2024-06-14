import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:highty_inventory/presentation/constants/colors.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';

const double kPadding = 16.0;
const double kIconSize = 24.0;
const double kImageWidth = 150.0;

class StockDetail extends StatefulWidget {
  final String sku;

  const StockDetail({required this.sku, Key? key}) : super(key: key);

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  List<int> stock = [11, 11, 11, 11];
  late List<int> initialStock;
  bool isModified = false;

  @override
  void initState() {
    super.initState();
    initialStock = List.from(stock);
  }

  void checkIfModified() {
    setState(() {
      isModified = !listEquals(stock, initialStock);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(
          color: kAccentColor,
        ),
        title: Text(
          widget.sku,
          style: primaryWhite,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: kPadding),
            _buildStockList(),
            ElevatedButton(
              onPressed: isModified ? () {
                // Update stock logic
              } : null,
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
      ),
    );
  }

  Widget _buildHeader() {
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
          Image.asset(
            'assets/150x150.png',
            width: kImageWidth,
          ),
          const SizedBox(height: kPadding / 2),
          Text(
            'White Plain Mandarin Shirt',
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
          size: ['S', 'M', 'L', 'XL'][index],
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
