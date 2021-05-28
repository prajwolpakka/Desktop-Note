import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditProvider extends ChangeNotifier {
  int _credit = 30;
  fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _credit = prefs.getInt('credit') ?? 30;
    notifyListeners();
  }

  CreditProvider() {
    fetchData();
  }

  get credit => _credit;

  decreaseCredit() async {
    _credit--;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('credit', _credit);
    notifyListeners();
  }

  resetCredit() async {
    _credit = 30;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('credit', _credit);
    notifyListeners();
  }
}
