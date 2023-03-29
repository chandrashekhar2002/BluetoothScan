import 'package:flutter/material.dart';

AppBar commonAppBar({required String title}) {
  return AppBar(
    backgroundColor: Colors.black,
    title: Text(title),
    elevation: 3.0,
    centerTitle: true,
    toolbarOpacity: 0.7,
    shadowColor: Colors.grey,
  );
}
