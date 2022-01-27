import 'package:flutter/material.dart';
import 'package:flutter_sport_inventory/providers/items.dart';
import 'package:flutter_sport_inventory/screens/add_item_screen.dart';
import 'package:flutter_sport_inventory/widgets/app_drawer.dart';
import 'package:flutter_sport_inventory/widgets/item_card.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late String username;
  late String role;

  var _isInit = true;
  var _isLoading = false;
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Items>(context, listen: false).fetchAndSetProduct();
  }

  @override
  void didChangeDependencies() {
    // Will run after the widget fully initialise but before widget build
    if (_isInit) {
      // for the first time..!!
      setState(() {
        _isLoading = true;
      });
      Provider.of<Items>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //======== Widget build ====================
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<Items>(builder: (context, itemData, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Sport Inventory'),
          backgroundColor: Colors.indigo,
          elevation: 0.5,
          actions: <Widget>[
            itemData.authDetail['role'] == 'Manager'
                ? Text('')
                : IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddItem.routeName, arguments: '');
                    },
                  ),
          ],
        ),
        body: Container(
          color: Colors.blueGrey,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                      Color.fromRGBO(51, 51, 255, 1).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.all(30),
                      //width: width * (0.9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome,',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            itemData.authDetail['username'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Divider(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              itemData.authDetail['role'].toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Items>(
                          builder: (context, itemData, child) {
                            return ListView.builder(
                                itemCount:
                                    itemData.authDetail['role'] == 'Manager'
                                        ? itemData.getItems.length
                                        : itemData.getStaffItems.length,
                                itemBuilder: (context, index) {
                                  return itemData.authDetail['role'] ==
                                          'Manager'
                                      ? ItemCard(
                                          itemData.getItems[index].id,
                                          itemData.getItems[index].asset_no,
                                          itemData.getItems[index].asset_name,
                                          itemData.getItems[index].asset_status,
                                        )
                                      : ItemCard(
                                          itemData.getStaffItems[index].id,
                                          itemData
                                              .getStaffItems[index].asset_no,
                                          itemData
                                              .getStaffItems[index].asset_name,
                                          itemData.getStaffItems[index]
                                              .asset_status,
                                        );
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
      );
    });
  }
}
