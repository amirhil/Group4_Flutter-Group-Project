import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/items.dart';

class AddItem extends StatelessWidget {
  static const routeName = '/add-items';

  @override
  Widget build(BuildContext context) {
    String assetName = "";
    String dateRegistered = "";
    String location = "";
    String status = "";

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text("Add Item"),
        backgroundColor: Colors.indigo,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Container(
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
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/convers_wallpaper.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Item Name",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
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
                      color: Colors.black,
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
                    Provider.of<Items>(context, listen: false).addItem(
                      assetName,
                      DateFormat.yMMMd().format(DateTime.now()).toString(),
                      location,
                      "Active",
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Add Item",
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
      ),
    );
  }
}
