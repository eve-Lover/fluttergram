import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
    appBarTheme: const AppBarTheme(
        color: Colors.white,
        //elevation: 1, // 그림자
        actionsIconTheme:
        IconThemeData(
            color: Colors.red
        ),
        titleTextStyle:
        TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
        )
    ),
    iconTheme: const IconThemeData( color: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Colors.black)
        )
        ),
);