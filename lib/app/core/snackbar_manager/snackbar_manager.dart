import 'package:flutter/material.dart';

abstract class SnackBarManager {
  static final GlobalKey<ScaffoldMessengerState> snackKey =
      GlobalKey<ScaffoldMessengerState>();
  SnackBarManager._();

  static void show({
    required String message,
    Color backgroundColor = Colors.white,
    required IconData icon,
    required Color iconColor,
  }) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Row(children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () => snackKey.currentState?.hideCurrentSnackBar(),
          borderRadius: BorderRadius.circular(100),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.close, color: Colors.black54),
          ),
        )
      ]),
    );
    snackKey.currentState?.showSnackBar(snackBar);
  }
}
