import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Item with ChangeNotifier {
  final String id;
  final String asset_no;
  final String asset_name;
  final String date_registered;
  final String asset_location;
  final String asset_status;

  Item({
    required this.id,
    required this.asset_no,
    required this.asset_name,
    required this.date_registered,
    required this.asset_location,
    required this.asset_status,
  });
}
