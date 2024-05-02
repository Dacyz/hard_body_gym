import 'package:flutter/material.dart';

class AlertHelper {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
    required String buttonText,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog.adaptive(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText),
          )
        ],
      ),
    );
  }
}
