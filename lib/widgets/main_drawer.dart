import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
              title: Text('Hello Customer!!'),
              automaticallyImplyLeading: false,
              //never adds a back button
              backgroundColor: Theme.of(context).accentColor),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(
              Icons.shop,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.attach_money,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Manage Products',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          Spacer(),
          Divider(
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
