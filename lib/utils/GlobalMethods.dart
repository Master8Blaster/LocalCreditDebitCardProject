import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class GlobalMethods {
  static printLog(String msg) {
    if (kDebugMode) {
      print("Flutter : $msg");
    }
  }

  static showSnackBar(BuildContext context, String msg, Color backGroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backGroundColor,
      ),
    );
  }
}
