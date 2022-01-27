import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime? _expiryDate = null;
  late String _userId;
  late Timer? _authTimer = null;

  late String _userName;
  late String _userRole;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get getUserId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDofc3UjR-zjyqyeZVkzekrvqPnkGfj_XY');
    var roleUrl =
        'https://fbsportinvent-e87e9-default-rtdb.asia-southeast1.firebasedatabase.app/users.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      print(json.decode(response.body)); // For debug console...
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken']; // Get the id token...
      _userId = responseData['localId']; // Get the user id
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      if (urlSegment == 'signUp') {
        // if it's signup to save role...
        final responseRole = await http.post(
          Uri.parse(roleUrl),
          body: json.encode({
            'userId': getUserId,
            'user_Name': _userName,
            'user_Role': _userRole,
          }),
        );
        print('success : ' + responseRole.toString());
      }

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      print("Debug => Token value = " + _token);
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String()
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signupDetail(String userName, String userRole) async {
    _userName = userName;
    _userRole = userRole;
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('Debug 1 => No token in device...!');
      return false;
    }
    final extractedUserData = json
        .decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    print('Debug 2 => Token value = ' + _token);
    print('Debug 3 => User Id = ' + _userId);
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = '';
    _userId = '';
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    // final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    // _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    // _authTimer = Timer(Duration(seconds: 8), logout);
  }
}
