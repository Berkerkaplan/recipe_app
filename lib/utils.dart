import 'package:flutter/material.dart';


class Utils {
  // static void showSnackBar(BuildContext context, String text) =>
  //     Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));

  static void showSnackBar(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 3),
      content: Center(
        child: Text(
         text.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
    ));

}