import 'package:flutter/material.dart';
import 'package:highty_inventory/presentation/constants/colors.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:highty_inventory/presentation/constants/icons.dart';
import 'package:highty_inventory/presentation/screens/history_screen.dart';
import 'package:highty_inventory/presentation/screens/order_screen.dart';
import 'package:highty_inventory/presentation/screens/stock_screen.dart';
import 'package:iconify_flutter/icons/ph.dart'; 
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    OrderScreen(),
    StockScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Iconify(orderIcon, color: _selectedIndex == 0 ? Colors.amber : Colors.white),
            //icon: Icon(Icons.home),
            label: 'Orders'
          ),
          BottomNavigationBarItem(
            icon: Iconify(Ph.package_thin, color: _selectedIndex == 1 ? Colors.amber : Colors.white),
            label: 'Stock'
          ),
          BottomNavigationBarItem(
            icon: Iconify(historyIcon, color: _selectedIndex == 2 ? Colors.amber : Colors.white),
            label: 'History'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: kAccentColor,
        backgroundColor: kPrimaryColor,
        selectedLabelStyle: primary,
        unselectedLabelStyle: primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
