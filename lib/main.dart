import 'package:flutter/material.dart';
import 'package:gadaiyuk_terbaru/auth/signIn.dart';
import 'package:gadaiyuk_terbaru/page/splashScreen.dart';






void main() {
  runApp(const MyApp());
 
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage()
    );
  }
}




