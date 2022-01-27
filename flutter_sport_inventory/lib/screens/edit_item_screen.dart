import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// import 'package:hexcolor/hexcolor.dart';

import '../providers/items.dart';

class EditItem extends StatelessWidget {
  static const routeName = '/edit-items';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final itemId =
        ModalRoute.of(context)!.settings.arguments as String; // is the id!
    final loadedItem = Provider.of<Items>(
      context,
      listen: false,
    ).findById(itemId);
    String assetName = "";
    String dateRegistered = "";
    String location = "";
    String status = "";

    return Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          title: Text("Edit Item"),
          backgroundColor: Colors.indigo,
          elevation: 0.5,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height,
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
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(30),
                    //width: width * (0.9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.purple.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Asset No :" + loadedItem.asset_no,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Date Register :" + loadedItem.date_registered,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Status :" + loadedItem.asset_status,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    maxLength: 30,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Item Name",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      assetName = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Location",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      location = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      Provider.of<Items>(context, listen: false).updateItems(
                        itemId,
                        loadedItem.asset_no,
                        assetName,
                        loadedItem.date_registered,
                        location,
                        loadedItem.asset_status,
                      );

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
