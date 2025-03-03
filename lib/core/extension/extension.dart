import 'package:flutter/material.dart';

extension ExtensionContext on BuildContext {
  showSnackBar({required String message, bool success = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
