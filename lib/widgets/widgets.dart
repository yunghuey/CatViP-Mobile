
import 'package:CatViP/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Widgets extends ChangeNotifier {
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  String getFormattedDate(DateTime dateTime) {
    final now = DateTime.now();

    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      // Date is the same as the local date, calculate time difference in hours and minutes
      final timeDifference = now.difference(dateTime);

      if (timeDifference.inHours > 0) {
        // If the time difference is in hours, display hours
        return "${timeDifference.inHours} ${timeDifference.inHours == 1 ? 'hour' : 'hours'} ago";
      } else if (timeDifference.inMinutes > 0) {
        // If the time difference is in minutes, display minutes
        return "${timeDifference.inMinutes} ${timeDifference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
      } else {
        // If the time difference is less than a minute, display 'just now'
        return 'just now';
      }
    } else {
      // Date is not the same as the local date, display only the date
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }
}


