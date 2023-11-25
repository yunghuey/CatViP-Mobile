
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';

class IsFavorite extends ChangeNotifier {
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}
