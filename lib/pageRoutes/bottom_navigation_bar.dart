import 'package:CatViP/pageRoutes/navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatefulWidget {

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    // You can add specific actions for each tab here
    switch (index) {
      case 0:
      // Home button clicked
        print('Home button clicked');
        //Navigator.pushNamed(context, MyNavigator.initialRoute);
        Navigator.pushReplacementNamed(context, MyNavigator.initialRoute);
        break;
      case 1:
      // Add button clicked
        print('Add button clicked');
        //Navigator.pushNamed(context, MyNavigator.secondRoute);
        Navigator.pushReplacementNamed(context, MyNavigator.secondRoute);
        break;
      case 2:
      // Shop button clicked
        print('Shop button clicked');
        break;
      case 3:
      // Profile button clicked
        print('Profile button clicked');
        break;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop),
          label: 'Shop',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: Colors.black,
        ),
      ],
    );
  }
}
