import "package:flutter/material.dart";

class Dialogs {
  static void ShowSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.purple.withOpacity(0.7),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void ShowProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(child: CircularProgressIndicator()));
  }
}
