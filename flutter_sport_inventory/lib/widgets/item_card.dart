import 'package:flutter/material.dart';
import 'package:flutter_sport_inventory/screens/item_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/items.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final String assetNo;
  final String assetName;
  final String id;
  final String status;

  ItemCard(
    this.id,
    this.assetNo,
    this.assetName,
    this.status,
  );

  @override
  Widget build(BuildContext context) {
    //final item = Provider.of<Item>(context, listen: false);
    final loadedItem = Provider.of<Items>(
      context,
      listen: false,
    ).findById(id);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          itemDetailScreen.routeName,
          arguments: id,
        );
      },
      child: Consumer<Items>(builder: (context, itemData, child) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 70,
            child: Row(
              children: [
                Text(assetNo),
                Spacer(),
                Text(assetName),
                Spacer(),
                //Text(status),
                itemData.authDetail['role'] == 'Manager'
                    ? Text(status)
                    : IconButton(
                        onPressed: () {
                          Provider.of<Items>(context, listen: false)
                              .updateStatus(id, loadedItem);
                        },
                        icon: Icon(Icons.delete),
                      )
              ],
            ),
          ),
        );
      }),
    );
  }
}
