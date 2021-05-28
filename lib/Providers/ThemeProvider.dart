import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkTheme = false;
  fetchTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool('darkTheme') ?? false;
    notifyListeners();
  }

  ThemeProvider() {
    fetchTheme();
  }
  get darkTheme => _darkTheme;

  changeTheme() async {
    _darkTheme = !_darkTheme;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', _darkTheme);
    notifyListeners();
  }
}
