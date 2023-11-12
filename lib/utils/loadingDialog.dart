import 'package:flutter/material.dart';

class LoadingDialog {
  BuildContext? _context;

  void show(BuildContext context) {
    _context = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void hide() {
    if (_context != null) {
      Navigator.of(_context!, rootNavigator: true).pop();
      _context = null;
    }
  }
}
