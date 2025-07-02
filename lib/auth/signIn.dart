import 'dart:convert';
import '../db/dbHelpers.dart';
import 'package:mysql1/mysql1.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gadaiyuk_terbaru/auth/singnUp.dart';
import 'package:gadaiyuk_terbaru/page/bottomNav.dart';
import 'package:gadaiyuk_terbaru/page/landscape_mode.dart';
import 'package:gadaiyuk_terbaru/gadai/cekStatusGadai.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _nomerController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true;

// Fungsi untuk melakukan login


  Future<void> _login() async {
    String nomer = _nomerController.text.trim();
    String password = _passwordController.text.trim();
    try {
      bool loginResult = await DatabaseHelper.loginUser(nomer, password);
      if (loginResult) {
        // Registrasi berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CekStatusGadai()),
        );
      } else {
        // Registrasi gagal
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Erorr',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Times New Roman')),
              content: Text('Login Gagal',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w300,
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('OK',
                      style: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Color(0xff4545ff))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erorr',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w400,
                )),
            content: Text('Server error',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w300,
                )),
            actions: <Widget>[
              TextButton(
                child: Text('OK',
                    style: TextStyle(
                        fontFamily: 'Times New Roman',
                        color: Color(0xff4545ff))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Text(
                    'Masuk',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Times New Roman'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    keyboardType: TextInputType.phone,
                    controller: _nomerController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Nomer Hp',
                      hintText: 'Masukan Nomer Hp',
                      labelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontFamily: 'Times New Roman'),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Color(0xff4545ff),
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff4545ff), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    cursorColor: const Color(0xff4545ff),
                    obscureText: _isObscure,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      labelText: 'Password',
                      hintText: 'Masukan Password',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      labelStyle: const TextStyle(
                          color: Color(0xff4545ff),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Times New Roman'),
                      prefixIcon: const Icon(
                        Iconsax.key,
                        color: Color(0xff4545ff),
                        size: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xff4545ff),
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff4545ff), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_nomerController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Error',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            content: Text(
                              'Harap lengkapi semua data',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Color(0xff4545ff),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      } else if (_passwordController.text.length < 6) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Times New Roman')),
                            content: Text(
                                'Password tidak boleh kurang dari 6 karakter',
                                style: TextStyle(
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w300,
                                )),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK',
                                    style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                        color: Color(0xff4545ff))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        await _login();
        
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4545ff),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      minimumSize: Size(0, 45),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Masuk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Apakah Belum punya akun?',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Times New Roman'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ));
                        },
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                              color: Color(0xff4545ff),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Times New Roman'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              )
            ),
        ),
        );
  }
}
