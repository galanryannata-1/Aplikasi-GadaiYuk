import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gadaiyuk_terbaru/auth/signIn.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({ Key? key }) : super(key: key);
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}
class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    openSplashScreen();
  }
  openSplashScreen() async {
    var durasiSplash = const Duration(seconds: 6);
    return Timer(durasiSplash, () {
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Login();
        })
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: 1000,
          height: 500,
        ),
      ),
    );
  }
}