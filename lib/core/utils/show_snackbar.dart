import 'package:flutter/material.dart';

/// hideCurrentSnackBar()
/// we are using this function because if there are 2 snackbars that are in progress, we want the previous snackbar to get
/// hidden away when the new snackbar appears.

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
}
