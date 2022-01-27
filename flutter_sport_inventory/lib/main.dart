import 'package:flutter/material.dart';
import 'package:flutter_sport_inventory/providers/items.dart';
import 'package:flutter_sport_inventory/screens/add_item_screen.dart';
import 'package:flutter_sport_inventory/screens/edit_item_screen.dart';
import 'package:flutter_sport_inventory/screens/item_detail_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_sport_inventory/providers/auth.dart';
import 'package:flutter_sport_inventory/screens/auth_screen.dart';
import 'package:flutter_sport_inventory/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Items>(
          create: (ctx) => Items(null, null, []),
          update: (ctx, auth, previousProducts) => Items(
            auth.token,
            auth.getUserId,
            previousProducts == null ? [] : previousProducts.getItems,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => (MaterialApp(
          title: 'Sport Inventory',
          home: auth.isAuth ? homeScreen() : AuthScreen(),
          routes: {
            itemDetailScreen.routeName: (ctx) => itemDetailScreen(),
            AddItem.routeName: (ctx) => AddItem(),
            EditItem.routeName: (ctx) => EditItem(),
          },
        )),
      ),
    );
  }
}
