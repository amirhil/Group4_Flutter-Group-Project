import 'package:flutter/material.dart';
import 'package:flutter_sport_inventory/providers/items.dart';
import 'package:flutter_sport_inventory/screens/add_item_screen.dart';
import 'package:flutter_sport_inventory/screens/edit_item_screen.dart';
import 'package:provider/provider.dart';

class itemDetailScreen extends StatelessWidget {
  static const routeName = '/detailScreen';

  @override
  Widget build(BuildContext context) {
    final itemId =
        ModalRoute.of(context)!.settings.arguments as String; // is the id!
    final loadedItem = Provider.of<Items>(
      context,
      listen: false,
    ).findById(itemId);
    return Consumer<Items>(
      builder: (context, itemData, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Sport Inventory'),
            backgroundColor: Colors.indigo,
            elevation: 0.5,
            actions: <Widget>[
              itemData.authDetail['role'] == 'Manager'
                  ? Text('')
                  : IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditItem.routeName,
                            arguments: loadedItem.id);
                      },
                    ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // SizedBox(
                //   height: 10,
                // ),

                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.indigoAccent, Colors.purple])),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    height: 300.0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            border: Border.all(),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          //width: double.infinity,

                          child: Text(
                            loadedItem.asset_no,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          //width: double.infinity,
                          child: Text(
                            loadedItem.asset_name,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 22.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                child: Text(
                                  loadedItem.date_registered,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedItem.asset_location,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedItem.asset_status,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
