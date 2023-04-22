import 'package:flutter/material.dart';
import 'package:via_cep/pages/home/home_page.dart';


void MyApp() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.red),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
  ));
}