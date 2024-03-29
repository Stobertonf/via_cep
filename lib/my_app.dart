import 'package:flutter/material.dart';
import 'package:via_cep/pages/home/home_page.dart';
import 'package:via_cep/pages/register/register_cep.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}