import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/item.dart';

class Items with ChangeNotifier {
  late final String? authToken;
  late final String? _userId;

  Map<String, String> _authDetail = {
    'username': '',
    'role': '',
  };

  Items(this.authToken, this._userId, this._items);

  List<Item> _items = [];
  List<Item> _staffItems = [];

  List<Item> get getItems {
    return [..._items];
  }

  List<Item> get getStaffItems {
    return [..._staffItems];
  }

  Map<String, String> get authDetail {
    retrieveUser(getUserId);
    return _authDetail;
  }

  String? get getUserId {
    return _userId;
  }

  Item findById(String id) {
    return _items.firstWhere((itm) => itm.id == id);
  }

  Future<void> addItem(
    String assetName,
    String dateRegistered,
    String location,
    String status,
  ) async {
    final total = getItems.length + 1;
    String assetNo = 'A-' + total.toString();
    const url =
        'https://fbsportinvent-e87e9-default-rtdb.asia-southeast1.firebasedatabase.app/items.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'assetNo': assetNo,
          'assetName': assetName,
          'dateRegistered': dateRegistered,
          'assetLocation': location,
          'status': status,
        }),
      );

      Item item = Item(
        asset_no: 'A-' + total.toString(),
        asset_name: assetName,
        date_registered: dateRegistered,
        asset_location: location,
        asset_status: status,
        id: json.decode(response.body)['name'],
      );
      _items.add(item);
    } catch (error) {
      print(error);
      throw error;
    }

    notifyListeners();
  }

  Future<void> retrieveUser(String? userId) async {
    final filterString = 'orderBy="userId"&equalTo="$userId"';
    var url =
        'https://fbsportinvent-e87e9-default-rtdb.asia-southeast1.firebasedatabase.app/users.json?$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        extractedData.forEach((userid, userData) {
          _authDetail['username'] = userData['user_Name'];
          _authDetail['role'] = userData['user_Role'];
        });

        notifyListeners();
      }
    } catch (error) {
      print('Dok leh dapat data');
      throw (error);
    }
  }

  Future<void> fetchAndSetProduct() async {
    var url =
        'https://fbsportinvent-e87e9-default-rtdb.asia-southeast1.firebasedatabase.app/items.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));
      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        final List<Item> loadedItems = [];
        final List<Item> staffItems = [];
        extractedData.forEach((itemId, itemData) {
          loadedItems.add(Item(
            id: itemId,
            asset_no: itemData['assetNo'],
            asset_name: itemData['assetName'],
            date_registered: itemData['dateRegistered'],
            asset_location: itemData['assetLocation'],
            asset_status: itemData['status'],
          ));
          if (itemData['status'] != 'Deprecated') {
            staffItems.add(Item(
              id: itemId,
              asset_no: itemData['assetNo'],
              asset_name: itemData['assetName'],
              date_registered: itemData['dateRegistered'],
              asset_location: itemData['assetLocation'],
              asset_status: itemData['status'],
            ));
          }
        });

        _items = loadedItems;
        _staffItems = staffItems;

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateStatus(String id, Item newItem) async {
    final itemIndex = _items.indexWhere((itm) => itm.id == id);
    if (itemIndex >= 0) {
      var url =
          'https://fbsportinvent-e87e9-default-rtdb.asia-southeast1.firebasedatabase.app/items/$id.json';

      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({
          'assetNo': newItem.asset_no,
          'assetName': newItem.asset_name,
          'dateRegistered': newItem.date_registered,
          'assetLocation': newItem.asset_location,
          'status': 'Deprecated',
        }),
      );
      print(newItem.asset_no + " status updated = Deprecated");
      _staffItems.removeWhere((trx) => trx.id == id);
      _items[itemIndex] = newItem;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> updateItems(
    String id,
    String assetNo,
    String assetName,
    String dateRegistered,
    String location,
    String status,
  ) async {
    final itemIndex = _items.indexWhere((itm) => itm.id == id);
    if (itemIndex >= 0) {
      var url =
          'https://fbsportinvent-e87e9-default-rtdb.asia-southeast1.firebasedatabase.app/items/$id.json?';
      Item loadedItems;
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({
          'assetNo': assetNo,
          'assetName': assetName,
          'dateRegistered': dateRegistered,
          'assetLocation': location,
          'status': status,
        }),
      );
      loadedItems = Item(
        id: id,
        asset_no: assetNo,
        asset_name: assetName,
        date_registered: dateRegistered,
        asset_location: location,
        asset_status: status,
      );
      print(assetNo + " data updated");
      print(assetName);
      //_staffItems.removeWhere((trx) => trx.id == id);
      _items[itemIndex] = loadedItems;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
