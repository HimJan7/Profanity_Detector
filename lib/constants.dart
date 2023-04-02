import 'package:flutter/material.dart';

const kRoundInputDecoration = InputDecoration(
  hintText: 'Search Companies',
  hintStyle: TextStyle(color: Color(0xFF424242)),
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
