import 'package:flutter/material.dart';

class ShowFlushbar {
  static void showFloatingFlushbar(
      BuildContext context, String _title, String _message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$_title\n$_message'),
      duration: const Duration(seconds: 3),
    ));
  }
}
