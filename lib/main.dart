// @dart=2.9

import 'package:flutter/material.dart';
import 'package:hunters_gif/ui/home_page.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(hintColor: Colors.white)
  ));
}


