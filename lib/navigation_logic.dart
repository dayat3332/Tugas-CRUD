import 'package:flutter/material.dart';
import 'ip_detail_screen.dart';

class NavigationLogic {
  static void openIPDetail(
    BuildContext context, {
    required String title,
    required String author,
    required String price,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IPDetailScreen(
          title: title,
          author: author,
          price: price,
        ),
      ),
    );
  }
}
